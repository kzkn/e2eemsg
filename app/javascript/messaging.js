export class Session {
  constructor() {
    this.masterKey = null
    this.nodes = new Map()
  }

  isInitialized() {
    return !!this.masterKey
  }

  obtainNode(id, keyPair) {
    let node = this.nodes.get(id)
    if (!node) {
      node = new Node(this, keyPair)
      this.nodes.set(id, node)
    }
    return node
  }

  async initialize(email, password) {
    this.email = email
    this.masterKey = await this.#generateMasterKey(password)
    return this.#encryptPasswordForAuthenticate(email, password)
  }

  async generateKeyPair() {
    const keyPair = await window.crypto.subtle.generateKey(
      {
        name: "RSA-OAEP",
        modulusLength: 4096,
        publicExponent: new Uint8Array([1, 0, 1]),
        hash: "SHA-256",
      },
      true,
      ["encrypt", "decrypt"],
    );

    const publicKey = await exportPublicKey(keyPair.publicKey)
    const privKey = await exportPrivateKey(keyPair.privateKey)
    const encPrivKey = await encryptData(this.masterKey, privKey)
    return {
      publicKey: btoa(ab2str(publicKey)),
      encryptedPrivateKey: btoa(ab2str(encPrivKey.cipher)),
      encryptedPrivateKeyIv: btoa(ab2str(encPrivKey.iv)),
    }
  }

  async #generateMasterKey(password) {
    const salt = await this.#masterKeySalt()
    return await deriveMasterKey(password, salt)
  }

  async #masterKeySalt() {
    return sha256(str2ab(this.email))
  }

  async #encryptPasswordForAuthenticate(email, password) {
    const key = await deriveMasterKey(password, `${email}_auth`)
    const buf = await window.crypto.subtle.exportKey("raw", key)
    return btoa(ab2str(buf))
  }
}

class Node {
  constructor(session, keyPair) {
    this.session = session
    this.keyPair = keyPair
  }

  async encrypt(data) {
    const cipher = await window.crypto.subtle.encrypt(
      { name: "RSA-OAEP" },
      await this.publicKey(),
      data,
    );
    return { cipher }
  }

  async publicKey() {
    return await crypto.subtle.importKey(
      "spki",
      str2ab(atob(this.keyPair.publicKey)),
      { name: "RSA-OAEP", hash: "SHA-256" },
      false,
      ["encrypt"]
    )
  }

  async privateKey() {
    return await decryptText(
      this.session.masterkey,
      this.keyPair.encryptedPrivateKeyIv,
      this.keyPair.encryptedPrivateKeyCipher,
    )
  }
}

export class PlainMessage {
  constructor(plainText) {
    this.plainText = plainText
  }

  async encryptFor(node) {
    const key = await generateKey()
    const msg = await encryptText(key, this.plainText)
    const exportedKey = await window.crypto.subtle.exportKey("raw", key)
    const encryptedKey = await node.encrypt(exportedKey)
    return new EncryptedMessage(
      node,
      btoa(ab2str(msg.cipher)),
      btoa(ab2str(msg.iv)),
      btoa(ab2str(encryptedKey.cipher))
    )
  }
}

class EncryptedMessage {
  constructor(node, cipher, iv, encryptedKey) {
    this.node = node
    this.cipher = cipher
    this.iv = iv
    this.encryptedKey = encryptedKey
  }

  async decrypt() {
    const key = this.#decryptKey()
    const msg = await decryptText(
      key,
      str2ab(atob(this.iv)),
      str2ab(atob(this.cipher))
    )
    return ab2str(msg)
  }

  async #decryptKey() {
    const exportedKey = await this.node.decrypt(this.encryptedKey)
    return await window.crypto.subtle.importKey(
      "raw",
      exportedKey,
      "AES-GCM",
      true,
      ["encrypt", "decrypt"],
    )
  }
}

function ab2str(buf) {
  return String.fromCharCode.apply(null, new Uint8Array(buf))
}

function str2ab(str) {
  const buf = new ArrayBuffer(str.length)
  const bufView = new Uint8Array(buf)
  for (let i = 0, strLen = str.length; i < strLen; i++) {
    bufView[i] = str.charCodeAt(i)
  }
  return buf
}

async function sha256(buf) {
  const hash = await crypto.subtle.digest("SHA-256", buf)
  const hashArray = Array.from(new Uint8Array(hash))
  const hashHex = hashArray
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("")
  return hashHex
}

function getKeyMaterial(password) {
  const enc = new TextEncoder()
  return window.crypto.subtle.importKey(
    "raw",
    enc.encode(password),
    "PBKDF2",
    false,
    ["deriveBits", "deriveKey"],
  )
}

async function deriveMasterKey(password, salt) {
  const keyMaterial = await getKeyMaterial(password)
  return await window.crypto.subtle.deriveKey(
    {
      name: "PBKDF2",
      salt: str2ab(salt),
      iterations: 100000,
      hash: "SHA-256",
    },
    keyMaterial,
    { name: "AES-GCM", length: 256 },
    true,
    ["encrypt", "decrypt"],
  )
}

async function exportPublicKey(key) {
  return await window.crypto.subtle.exportKey("spki", key)
}

async function exportPrivateKey(key) {
  return await window.crypto.subtle.exportKey("pkcs8", key);
}

async function encryptData(key, data) {
  const iv = window.crypto.getRandomValues(new Uint8Array(12));
  const cipher = await window.crypto.subtle.encrypt(
    { name: "AES-GCM", iv: iv },
    key,
    data,
  );
  return { cipher, iv }
}

async function encryptText(key, text) {
  const enc = new TextEncoder();
  return await encryptData(key, enc.encode(text))
}

async function generateKey() {
  const rawkey = window.crypto.getRandomValues(new Uint8Array(16));
  return await window.crypto.subtle.importKey(
    "raw",
    rawkey,
    "AES-GCM",
    true,
    ["encrypt", "decrypt"],
  );
}

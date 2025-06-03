export class Session {
  constructor() {
    this.masterKey = null
  }

  isInitialized() {
    return !!this.masterKey
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

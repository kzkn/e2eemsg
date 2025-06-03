class Session {
  constructor(email) {
    this.email = email
    this.masterKey = null
  }

  isInitialized() {
    return !!this.masterKey
  }

  async initialize(password) {
    this.masterKey = await this.#generateMasterKey(password)
  }

  async #generateMasterKey(password) {
    return deriveMasterKey(password, await this.#masterKeySalt())
  }

  #masterKeySalt() {
    return sha256(str2ab(this.email))
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
      this.keyPair.publicKey,
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

  #decryptKey() {
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

class PlainMessage {
  constructor(plainText) {
    this.plainText = plainText
  }
  
  encryptFor(node) {
    const key = await generateKey()
    const msg = await encryptText(key, this.plainText)
    const exportedKey = await window.crypto.subtle.exportKey("raw", key)
    const encryptedKey = await node.encrypt(exportedKey)
    return new EncryptedMessage(
      node,
      btoa(ab2str(msg.cipher)),
      btoa(ab2str(msg.iv)),
      btoa(ab2str(encryptedKey))
    )
  }
}

class Messenger {
  constructor(session, keyPair) {
    this.session = session
    this.me = new Node(session, keyPair)
    this.others = []
  }

  async broadcast(messageText) {
    const msg = new PlainMessage(messageText)
    await Promise.all(this.others.map(node => this.#deliverTo(node, msg)))
  }

  #deliverTo(receiver, plainMessage) {
    const encryptedMessage = await plainMessage.encryptFor(receiver)
    // TODO: submit encryptedMessage
  }

  async receive(cipherText, ivText, encryptedKeyText) {
    const msg = new Encryptedmessage(this.me, cipherText, ivText, encryptedKeyText)
    return await msg.decrypt()
  }
}

// やりたいこと
// 入力されたパスワードからマスターキーを生成したい
function getKeyMaterial(password) {
  const enc = new TextEncoder();
  return window.crypto.subtle.importKey(
    "raw",
    enc.encode(password),
    "PBKDF2",
    false,
    ["deriveBits", "deriveKey"],
  );
}

async function deriveMasterKey(password, salt) {
  const keyMaterial = await getKeyMaterial(password);
  return await window.crypto.subtle.deriveKey(
    {
      name: "PBKDF2",
      salt,
      iterations: 100000,
      hash: "SHA-256",
    },
    keyMaterial,
    { name: "AES-GCM", length: 256 },
    true,
    ["encrypt", "decrypt"],
  )
}

var salt = window.crypto.getRandomValues(new Uint8Array(12))
var masterkey = await deriveMasterKey('aaaaaaaaaaaaa', salt)


// キーペアを生成したい
var keyPair = await window.crypto.subtle.generateKey(
  {
    name: "RSA-OAEP",
    modulusLength: 4096,
    publicExponent: new Uint8Array([1, 0, 1]),
    hash: "SHA-256",
  },
  true,
  ["encrypt", "decrypt"],
);

// キーペアの公開鍵をテキスト化したい
function ab2str(buf) {
  return String.fromCharCode.apply(null, new Uint8Array(buf));
}

async function exportCryptoKey(key) {
  const exported = await window.crypto.subtle.exportKey("spki", key);
  const exportedAsString = ab2str(exported);
  return window.btoa(exportedAsString);
}

var exportedPubKeyText = await exportCryptoKey(keyPair.publicKey)

// キーペアの秘密鍵をマスターキーで暗号化したい

async function exportPrivateCryptoKey(key) {
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

var exportedPrivateKey = await exportPrivateCryptoKey(keyPair.privateKey)
var encryptedPrivateKey = await encryptData(masterkey, exportedPrivateKey)

// 暗号化した秘密鍵をテキスト化したい
var exportedEncryptedPrivateKey = { cipher: btoa(ab2str(encryptedPrivateKey.cipher)), iv: btoa(ab2str(encryptedPrivateKey.iv)) }

// テキスト化された暗号化された秘密鍵をマスターキーで復元したい
function str2ab(str) {
  const buf = new ArrayBuffer(str.length);
  const bufView = new Uint8Array(buf);
  for (let i = 0, strLen = str.length; i < strLen; i++) {
    bufView[i] = str.charCodeAt(i);
  }
  return buf;
}

async function decryptText(key, ivtext, ciphertext) {
  const iv = str2ab(atob(ivtext))
  const cipher = str2ab(atob(ciphertext))
  // iv 値は暗号化に使用した値と同じ
  return await window.crypto.subtle.decrypt({ name: "AES-GCM", iv }, key, cipher);
}

var privateKeyRaw = await decryptText(masterkey, exportedEncryptedPrivateKey.iv, exportedEncryptedPrivateKey.cipher)

// テキスト化された公開鍵を復元したい
var pubkeyRaw = str2ab(atob(exportedPubKeyText))

// 適当な文字列を共通鍵暗号の鍵として使いたい
function generateKey() {
  const rawkey = window.crypto.getRandomValues(new Uint8Array(16));
  return window.crypto.subtle.importKey(
    "raw",
    rawkey,
    "AES-GCM",
    true,
    ["encrypt", "decrypt"],
  );
}

// 適当な文字列から作った共通鍵暗号の鍵でメッセージを暗号化したい
var text = 'hogehoge'
var key = await generateKey()
var encryptedMsg = await encryptText(key, text)
var exportedEncryptedMsg = {
  iv: btoa(ab2str(encryptedMsg.iv)),
  cipher: btoa(ab2str(encryptedMsg.cipher)),
}

// キーペアの公開鍵で共通鍵暗号の鍵を暗号化したい
var exportedKey = await window.crypto.subtle.exportKey("raw", key);
var pubkey = await crypto.subtle.importKey("spki", pubkeyRaw, { name: "RSA-OAEP", hash: "SHA-256" }, false, ["encrypt"])

async function encryptTextByPubkey(key, data) {
  const cipher = await window.crypto.subtle.encrypt(
    { name: "RSA-OAEP" },
    key,
    data,
  );
  return { cipher }
}

var encryptedKey = await encryptTextByPubkey(pubkey, exportedKey)
var encryptedKeyText = btoa(ab2str(encryptedKey.cipher))

// キーペアの秘密鍵で暗号化された共通鍵暗号の鍵を復元したい
async function decryptTextByPrivateKey(key, cipherText) {
  const plain = await window.crypto.subtle.decrypt(
    { name: "RSA-OAEP" },
    key,
    str2ab(atob(cipherText)),
  );
  return plain
}

var privkey = await crypto.subtle.importKey("pkcs8", privateKeyRaw, { name: "RSA-OAEP", hash: "SHA-256" }, false, ["decrypt"])
var decryptedKey = await decryptTextByPrivateKey(privkey, encryptedKeyText)
var importedKey = await window.crypto.subtle.importKey(
  "raw",
  decryptedKey,
  "AES-GCM",
  true,
  ["encrypt", "decrypt"],
);

// 復元した共通鍵で暗号化されたメッセージを復元したい
var decryptedMsg = await decryptText(importedKey, exportedEncryptedMsg.iv, exportedEncryptedMsg.cipher)
var decryptedMsgText = ab2str(decryptedMsg)

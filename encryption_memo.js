// やりたいこと
// キーペアを生成したい
let keyPair = await window.crypto.subtle.generateKey(
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
  const exportedAsBase64 = window.btoa(exportedAsString);
  return `-----BEGIN PUBLIC KEY-----\n${exportedAsBase64}\n-----END PUBLIC KEY-----`;
}

let exportedPubKey = await exportCryptoKey(keyPair.publicKey)

// キーペアの秘密鍵をマスターキーで暗号化したい

async function exportPrivateCryptoKey(key) {
  const exported = await window.crypto.subtle.exportKey("pkcs8", key);
  const exportedAsString = ab2str(exported);
  const exportedAsBase64 = window.btoa(exportedAsString);
  return `-----BEGIN PRIVATE KEY-----\n${exportedAsBase64}\n-----END PRIVATE KEY-----`;
}

let exportedPrivateKey = await exportPrivateCryptoKey(keyPair.privateKey)

// 暗号化した秘密鍵をテキスト化したい

// テキスト化された暗号化された秘密鍵をマスターキーで復元したい
// テキスト化された公開鍵を復元したい

// 適当な文字列を共通鍵暗号の鍵として使いたい
// 適当な文字列から作った共通鍵暗号の鍵でメッセージを暗号化したい
// キーペアの公開鍵で共通鍵暗号の鍵を暗号化したい
// キーペアの秘密鍵で暗号化された共通鍵暗号の鍵を復元したい

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

let masterkey = await deriveMasterKey('aaaaaaaaaaaaa')

class KeyPair < ApplicationRecord
  belongs_to :user
end


# key
# hogehoge


# keyPair = await window.crypto.subtle.generateKey(
#   {
#     name: "ECDSA",
#     namedCurve: "P-384",
#   },
#   true,
#   ["sign", "verify"],
# );

# crypto.subtle.exportKey('pkcs8', keyPair.privateKey).then((x) => {console.log('x', x); __priv=x;}).catch((err) => console.log('catch', err))

# crypto.subtle.exportKey('raw', keyPair.publicKey).then((x) => {console.log('x', x); __pub=x;}).catch((err) => console.log('catch', err))

# btoa(String.fromCharCode.apply(null, new Uint8Array(__priv)))

# private key
# MIG2AgEAMBAGByqGSM49AgEGBSuBBAAiBIGeMIGbAgEBBDBjaauNNZbXlKqTXmGR1M0cNvbiMtRZNCduB4mFUZS5Tse+v5JhR0H+TSpx8kL2hnKhZANiAAQJXNW/sQyFol/MvaZzJM/gDQ0BaeGPNfi+Q1QZNDXw5JczA3VF2y63hZDHazbKfPbWB6a+Pgsj7VOQShI+1mChoy0V0b79r3IkZnmdvn9YPyjanetFUwEYgZJrQ8MYXcM=

# btoa(String.fromCharCode.apply(null, new Uint8Array(__pub)))

# public key
# BAlc1b+xDIWiX8y9pnMkz+ANDQFp4Y81+L5DVBk0NfDklzMDdUXbLreFkMdrNsp89tYHpr4+CyPtU5BKEj7WYKGjLRXRvv2vciRmeZ2+f1g/KNqd60VTARiBkmtDwxhdww==

# key = Uint8Array.from(atob("MIG2AgEAMBAGByqGSM49AgEGBSuBBAAiBIGeMIGbAgEBBDBjaauNNZbXlKqTXmGR1M0cNvbiMtRZNCduB4mFUZS5Tse+v5JhR0H+TSpx8kL2hnKhZANiAAQJXNW/sQyFol/MvaZzJM/gDQ0BaeGPNfi+Q1QZNDXw5JczA3VF2y63hZDHazbKfPbWB6a+Pgsj7VOQShI+1mChoy0V0b79r3IkZnmdvn9YPyjanetFUwEYgZJrQ8MYXcM=").split("").map(x => x.charCodeAt()))

# crypto.subtle.importKey('pkcs8', key, { name: "ECDSA", namedCurve: "P-384" }, true, ['sign', 'verify'])

# やりたいこと
# キーペアを生成したい
# キーペアの公開鍵をテキスト化したい
# キーペアの秘密鍵をマスターキーで暗号化したい
# 暗号化した秘密鍵をテキスト化したい

# テキスト化された暗号化された秘密鍵をマスターキーで復元したい
# テキスト化された公開鍵を復元したい

# 適当な文字列を共通鍵暗号の鍵として使いたい
# 適当な文字列から作った共通鍵暗号の鍵でメッセージを暗号化したい
# キーペアの公開鍵で共通鍵暗号の鍵を暗号化したい
# キーペアの秘密鍵で暗号化された共通鍵暗号の鍵を復元したい

import { Controller } from "@hotwired/stimulus"
import * as global from '../global'
import { EncryptedMessage } from '../messaging'

export default class extends Controller {
  static values = {
    cipher: String,
    iv: String,
    encryptedKey: String,
    keyPairId: String,
    publicKey: String,
    encryptedPrivateKey: String,
    encryptedPrivateKeyIv: String
  }

  async connect() {
    const enc = new EncryptedMessage(this.#node, this.cipherValue, this.ivValue, this.encryptedKeyValue)
    const plain = await enc.decrypt()
    this.element.textContent = plain
  }

  get #node() {
    const session = global.session()
    return session.obtainNode(this.keyPairIdValue, {
      publicKey: this.publicKeyValue,
      encryptedPrivateKey: this.encryptedPrivateKeyValue,
      encryptedPrivateKeyIv: this.encryptedPrivateKeyIvValue
    })
  }
}

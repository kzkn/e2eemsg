import { Controller } from "@hotwired/stimulus"
import * as global from '../global'
import { PlainMessage } from '../messaging'

export default class extends Controller {
  static targets = ['form', 'cipher', 'plain']

  async encrypt(ev) {
    ev.preventDefault()

    const plain = new PlainMessage(this.plainTarget.value)
    await Promise.all(this.cipherTargets.map(el => this.#encryptOn(el, plain)))

    this.formTarget.requestSubmit()
  }

  async #encryptOn(fields, plain) {
    const node = nodeOf(fields)
    const enc = await plain.encryptFor(node)
    fields.querySelector('[data-name=cipher]').value = enc.cipher
    fields.querySelector('[data-name=iv]').value = enc.iv
    fields.querySelector('[data-name=encrypted_key]').value = enc.encryptedKey
  }
}

function nodeOf(fields) {
  const session = global.session()
  return session.obtainNode(fields.dataset.keyPairId, { publicKey: fields.dataset.publicKey })
}

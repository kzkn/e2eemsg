import { Controller } from "@hotwired/stimulus"
import * as global from 'global'

export default class extends Controller {
  static targets = ['email', 'password', 'form']

  connect() {
    this.session = global.session()
  }

  async handleSubmit(ev) {
    ev.preventDefault()

    const email = this.emailTarget.value
    const password = this.passwordTarget.value

    this.formTarget.email.value = email
    this.formTarget.encrypted_password.value = await this.session.initialize(email, password)

    if (this.formTarget.public_key) {
      const keyPair = await this.session.generateKeyPair()
      this.formTarget.public_key.value = keyPair.publicKey
      this.formTarget.encrypted_private_key.value = keyPair.encryptedPrivateKey
      this.formTarget.encrypted_private_key_iv.value = keyPair.encryptedPrivateKeyIv
    }

    this.formTarget.requestSubmit()
  }
}

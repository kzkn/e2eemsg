import { Controller } from "@hotwired/stimulus"
import * as Popper from '@popperjs/core'

export default class extends Controller {
  static targets = ['button', 'tooltip', 'form']

  connect() {
    this.popper = Popper.createPopper(this.buttonTarget, this.tooltipTarget)
    document.addEventListener('click', this.#handleDocumentClick)
  }

  disconnect() {
    this.popper.destroy()
    document.removeEventListener('click', this.#handleDocumentClick)
  }

  toggle() {
    this.tooltipTarget.classList.toggle('shown')
  }

  pick(event) {
    const { detail } = event
    this.#submit(detail)
    this.#hide()
  }

  #hide() {
    this.tooltipTarget.classList.remove('shown')
  }

  get #isShown() {
    return this.tooltipTarget.classList.contains('shown')
  }

  #submit(emoji) {
    this.formTarget.emoji.value = JSON.stringify(emoji)
    this.formTarget.requestSubmit()
  }

  #handleDocumentClick = (event) => {
    if (this.#isOutside(event))
      this.#hide()
  }

  #isOutside(event) {
    const { target } = event
    return !this.buttonTarget.contains(target) && !this.tooltipTarget.contains(target)
  }
}

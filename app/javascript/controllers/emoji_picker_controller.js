import { Controller } from "@hotwired/stimulus"
import * as Popper from '@popperjs/core'

export default class extends Controller {
  static targets = ['button', 'tooltip', 'form']

  connect() {
    Popper.createPopper(this.buttonTarget, this.tooltipTarget)
  }

  toggle() {
    this.tooltipTarget.classList.toggle('shown')
  }

  pick(event) {
    const { detail } = event
    this.#submit(detail)
  }

  #submit(emoji) {
    this.formTarget.emoji.value = JSON.stringify(emoji)
    this.formTarget.requestSubmit()
  }
}

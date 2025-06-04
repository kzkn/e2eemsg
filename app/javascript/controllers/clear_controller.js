import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input']

  clearAll(ev) {
    const { detail: { success } } = ev
    if (!success)
      return

    for (const el of this.inputTargets)
      el.value = ''
  }
}

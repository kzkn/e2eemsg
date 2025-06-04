import { Controller } from "@hotwired/stimulus"
import * as global from 'global'

export default class extends Controller {
  connect() {
    const session = global.session()
    if (!session.isInitialized())
      location.href = `/session/edit?back_to=${encodeURIComponent(location.pathname)}`
  }
}

import { Session } from "messaging"

window.__Global = {}

export function session() {
  if (!window.__Global.session)
    window.__Global.session = new Session()
  return window.__Global.session
}

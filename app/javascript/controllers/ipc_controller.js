import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ipcHidden"]

  connect() {
    const ipcHiddenField = this.ipcHiddenTarget

    document.getElementById("requires_ipc_true").addEventListener("change", () => {
      ipcHiddenField.value = true

      window.dispatchEvent(new CustomEvent("ipc:changed", {
        detail: { value: true }
      }))
    })

    document.getElementById("does_not_require_ipc").addEventListener("change", () => {
      ipcHiddenField.value = false

      window.dispatchEvent(new CustomEvent("ipc:changed", {
        detail: { value: false }
      }))
    })
  }
}

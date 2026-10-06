import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = ["modal", "message", "confirmButton"]

  connect() {
    this.modal = Modal.getOrCreateInstance(this.modalTarget)
    this.initialFormValues = new Map()

    this.element.querySelectorAll("form").forEach((form) => {
      this.initialFormValues.set(form, this.formValueSignature(form))
      this.setButtonState(form)
    })
  }

  disconnect() {
    this.modal.dispose()
  }

  confirm(event) {
    const form = event.currentTarget

    if (form.dataset.confirmed === "true") {
      delete form.dataset.confirmed
      return
    }

    const section = event.submitter?.dataset.confirmSection
    if (!section) return

    event.preventDefault()
    this.pendingForm = form
    this.messageTarget.textContent = `Update changes to ${section}?`
    this.modal.show()
  }

  submit() {
    if (!this.pendingForm) return

    this.pendingForm.dataset.confirmed = "true"
    this.modal.hide()
    this.pendingForm.requestSubmit()
  }

  updateButtonState(event) {
    const form = event.target.closest("form")
    if (form && this.initialFormValues.has(form)) this.setButtonState(form)
  }

  setButtonState(form) {
    const updateButton = form.querySelector("button[type='submit'], input[type='submit']")
    if (updateButton) {
      const hasChanges = this.initialFormValues.get(form) !== this.formValueSignature(form)
      updateButton.disabled = !hasChanges || form.dataset.canUpdate === "false"
    }
  }

  formValueSignature(form) {
    return Array.from(new FormData(form).entries()).map(([name, value]) => `${name}=${value}`).join("&")
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "rows", "template", "heading", "remove"]
  static values = { minimum: Number }

  connect() {
    this.nextIndex = this.cardTargets.length
    this.refresh()
  }

  add() {
    const markup = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", String(this.nextIndex))
    this.nextIndex += 1
    this.rowsTarget.insertAdjacentHTML("beforeend", markup)
    this.refresh()
    this.cardTargets.at(-1)?.querySelector("input")?.focus()
  }

  remove(event) {
    if (this.cardTargets.length <= this.minimumValue) return

    event.currentTarget.closest("[data-supplier-list-target='card']")?.remove()
    this.refresh()
  }

  refresh() {
    const canRemove = this.cardTargets.length > this.minimumValue

    this.cardTargets.forEach((card, index) => {
      card.querySelector("[data-supplier-list-target='heading']").textContent = `Supplier ${index + 1}`
    })
    this.removeTargets.forEach((button) => { button.disabled = !canRemove })
  }
}

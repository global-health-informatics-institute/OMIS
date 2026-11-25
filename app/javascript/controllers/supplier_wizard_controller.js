import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "rows", "template", "previous", "next"]

  connect() {
    this.nextIndex = this.cardTargets.length
    this.currentIndex = 0
    this.refresh()
  }

  previous() {
    this.currentIndex = Math.max(this.currentIndex - 1, 0)
    this.refresh()
  }

  next() {
    this.currentIndex = Math.min(this.currentIndex + 1, this.cardTargets.length - 1)
    this.refresh()
  }

  add() {
    const markup = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", String(this.nextIndex))
    this.nextIndex += 1
    this.rowsTarget.insertAdjacentHTML("beforeend", markup)
    this.currentIndex = this.cardTargets.length - 1
    this.refresh()
    this.cardTargets.at(-1)?.querySelector("input")?.focus()
  }

  refresh() {
    const supplierCount = this.cardTargets.length

    this.cardTargets.forEach((card, index) => {
      card.classList.toggle("d-none", index !== this.currentIndex)
      card.querySelector("[data-supplier-wizard-target='heading']").textContent = `Supplier ${index + 1} of ${supplierCount}`
    })

    this.previousTargets.forEach((button) => { button.disabled = this.currentIndex === 0 })
    this.nextTargets.forEach((button) => { button.disabled = this.currentIndex >= supplierCount - 1 })
  }
}

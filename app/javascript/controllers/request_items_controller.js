import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rows", "row", "template", "heading", "count", "purpose", "budgetLine"]

  connect() {
    this.nextIndex = this.rowTargets.reduce((maximum, row) => {
      const index = Number(row.dataset.index)
      return Number.isInteger(index) ? Math.max(maximum, index + 1) : maximum
    }, 0)
    this.refresh()
    this.syncPurpose()
    this.syncBudget()
  }

  add() {
    const markup = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", String(this.nextIndex))
    this.nextIndex += 1
    this.rowsTarget.insertAdjacentHTML("beforeend", markup)
    this.refresh()
    this.rowTargets.at(-1)?.querySelector("input[type='text']")?.focus()
  }

  remove(event) {
    if (this.rowTargets.length <= 1) return

    event.currentTarget.closest("[data-request-items-target='row']")?.remove()
    this.refresh()
  }

  refresh() {
    const singleItem = this.rowTargets.length === 1

    this.rowTargets.forEach((row, index) => {
      row.querySelector("[data-request-items-target='heading']").textContent = `Item ${index + 1}`
      row.querySelector("[data-action='request-items#remove']").disabled = singleItem
    })
    this.countTarget.textContent = `${this.rowTargets.length} ${this.rowTargets.length === 1 ? "item" : "items"}`
  }

  syncPurpose() {
    const firstItemName = this.rowTargets[0]?.querySelector("input[name$='[item_name]']")
    this.purposeTarget.value = firstItemName?.value || ""
  }

  syncBudget() {
    const firstBudgetLine = this.rowTargets[0]?.querySelector("[data-budget-line-filter-target='line']")
    this.budgetLineTarget.value = firstBudgetLine?.value || ""
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["unitPrice", "levy", "mra", "lineTotal", "capMessage", "saveAction"]
  static values = {
    levyRate: Number,
    mraRate: Number,
    quantity: Number,
    threshold: Number,
    capRule: String
  }

  connect() {
    this.refresh()
  }

  refresh() {
    if (!this.hasUnitPriceTarget) return

    const total = this.calculateTotal()
    this.lineTotalTargets.forEach((target) => { target.textContent = this.formatMoney(total) })
    this.validateCap(total)
  }

  calculateTotal() {
    const unitPrice = Number(this.unitPriceTarget.value) || 0
    const attractsLevy = this.levyTargets.find((input) => input.checked)?.value === "true"
    const attractsMra = this.mraTargets.find((input) => input.checked)?.value === "true"
    const subtotal = this.quantityValue * unitPrice
    const total = subtotal + (attractsLevy ? subtotal * this.levyRateValue : 0) + (attractsMra ? subtotal * this.mraRateValue : 0)
    return total
  }

  validateCap(total) {
    let message = ""

    if (this.capRuleValue === "at_least" && total < this.thresholdValue) {
      message = `Quotation total must be at least ${this.formatMoney(this.thresholdValue)} MWK for IPC vendor analysis.`
    } else if (this.capRuleValue === "less_than" && total >= this.thresholdValue) {
      message = `Quotation total must be less than ${this.formatMoney(this.thresholdValue)} MWK for vendor analysis.`
    }

    this.capMessageTargets.forEach((target) => {
      target.textContent = message
      target.classList.toggle("text-danger", message.length > 0)
      target.classList.toggle("text-success", message.length === 0 && total > 0)
    })
    this.saveActionTargets.forEach((button) => { button.disabled = message.length > 0 })
  }

  formatMoney(amount) {
    return new Intl.NumberFormat("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(amount)
  }
}

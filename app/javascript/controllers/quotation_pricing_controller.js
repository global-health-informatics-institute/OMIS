import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "total", "capMessage", "saveAction"]
  static values = {
    levyRate: Number,
    mraRate: Number,
    threshold: Number,
    capRule: String
  }

  connect() {
    this.refresh()
  }

  refresh() {
    const total = this.itemTargets.reduce((sum, item) => sum + this.updateItemTotal(item), 0)
    this.totalTargets.forEach((target) => { target.textContent = this.formatMoney(total) })
    this.validateCap(total)
  }

  updateItemTotal(item) {
    const quantity = Number(item.dataset.quotationPricingQuantity) || 0
    const unitPrice = Number(item.querySelector('[data-quotation-pricing-target="unitPrice"]')?.value) || 0
    const attractsLevy = item.querySelector('[data-quotation-pricing-target="levy"]:checked')?.value === "true"
    const attractsMra = item.querySelector('[data-quotation-pricing-target="mra"]:checked')?.value === "true"
    const subtotal = quantity * unitPrice
    const total = subtotal + (attractsLevy ? subtotal * this.levyRateValue : 0) + (attractsMra ? subtotal * this.mraRateValue : 0)

    item.querySelector('[data-quotation-pricing-target="lineTotal"]').textContent = this.formatMoney(total)
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

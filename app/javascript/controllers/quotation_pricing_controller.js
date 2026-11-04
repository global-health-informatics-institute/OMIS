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

  sanitizePhone({ target }) {
    target.value = target.value.replace(/\D/g, "").slice(0, 10)
  }

sanitizeUnitPrice({ target }) {
  const caret = target.selectionStart
  const typedBeforeCaret = target.value.slice(0, caret).replace(/[^0-9.]/g, "").length

  const cleaned = target.value.replace(/[^0-9.]/g, "")
  const [whole, ...decimals] = cleaned.split(".")
  const formattedWhole = whole.replace(/^0+(?=\d)/, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",")

  target.value = decimals.length > 0
    ? `${formattedWhole}.${decimals.join("").slice(0, 2)}`
    : formattedWhole

  // keep the caret where the user was typing, ignoring commas
  let position = 0
  let count = 0
  while (position < target.value.length && count < typedBeforeCaret) {
    if (target.value[position] !== ",") count++
    position++
  }
  target.setSelectionRange(position, position)
}


  refresh() {
    if (!this.hasUnitPriceTarget) return

    const total = this.calculateTotal()
    this.lineTotalTargets.forEach((target) => { target.textContent = this.formatMoney(total) })
    this.validateCap(total)
  }

calculateTotal() {
  const unitPrice = Number(this.unitPriceTarget.value.replace(/,/g, "")) || 0
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

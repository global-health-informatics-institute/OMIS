import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["supplier", "item", "itemUnavailable", "unitPrice", "itemTotal", "supplierTotal", "lineTotal", "capMessage", "saveAction"]
  static values = {
    threshold: Number,
    upperThreshold: Number,
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

    this.itemUnavailableTargets.forEach((input) => this.applyItemAvailability(input))

    if (this.hasSupplierTarget) {
      const totals = this.supplierTargets.map((supplier) => {
        const total = this.calculateTotalFor(supplier)
        supplier.querySelector('[data-quotation-pricing-target="supplierTotal"]').textContent = this.formatMoney(total)
        return { supplier, total }
      })
      this.validateSupplierCaps(totals)
      return
    }

    const total = this.calculateTotalFor(this.element)

    this.lineTotalTargets.forEach((target) => { target.textContent = this.formatMoney(total) })
    this.validateCap(total)
  }

  syncCharge(event) {
    const { chargeItemId } = event.target.dataset
    const { value, checked } = event.target

    this.chargeTargets.forEach((charge) => {
      if (charge !== event.target && charge.dataset.chargeItemId === chargeItemId && charge.value === value) {
        charge.checked = checked
      }
    })
    this.refresh()
  }

  toggleItemAvailability(event) {
    this.applyItemAvailability(event.target)
    this.refresh()
  }

  applyItemAvailability(input) {
    const item = input.closest('[data-quotation-pricing-target="item"]')
    const unavailable = input.checked
    const editable = item.dataset.quotationPricingEditableValue === "true"

    item.classList.toggle("opacity-50", unavailable)
    item.querySelectorAll('[data-item-pricing-input="true"]').forEach((field) => {
      field.disabled = unavailable || !editable
    })
  }

  calculateTotalFor(container) {
    return Array.from(container.querySelectorAll('[data-quotation-pricing-target="item"]')).reduce((sum, item) => {
      const itemTotal = this.calculateItemTotal(item)
      item.querySelector('[data-quotation-pricing-target="itemTotal"]').textContent = this.formatMoney(itemTotal)
      return sum + itemTotal
    }, 0)
  }

  calculateItemTotal(item) {
    if (item.querySelector('[data-quotation-pricing-target="itemUnavailable"]')?.checked) return 0

    const quantity = Number(item.dataset.quotationPricingQuantityValue) || 0
    const unitPriceInput = item.querySelector('[data-quotation-pricing-target="unitPrice"]')
    const unitPrice = Number(unitPriceInput.value.replace(/,/g, "")) || 0
    const subtotal = quantity * unitPrice

    return Array.from(item.querySelectorAll('[data-quotation-pricing-target="charge"]:checked'))
      .reduce((total, charge) => {
        const value = Number(charge.dataset.chargeValue) || 0
        return charge.dataset.chargeType === "rate" ? total + (subtotal * value) : total + value
      }, subtotal)
  }

  validateCap(total) {
    const message = this.capMessage(total)

    this.capMessageTargets.forEach((target) => {
      this.setCapMessage(target, message, total)
    })
    this.saveActionTargets.forEach((button) => { button.disabled = message.length > 0 })
  }

  validateSupplierCaps(totals) {
    const messages = totals.map(({ supplier, total }) => ({ supplier, total, message: this.capMessage(total) }))

    messages.forEach(({ supplier, total, message }) => {
      const target = supplier.querySelector('[data-quotation-pricing-target="capMessage"]')
      this.setCapMessage(target, message, total)
    })
    this.saveActionTargets.forEach((button) => { button.disabled = messages.some(({ message }) => message.length > 0) })
  }

  capMessage(total) {
    if (this.capRuleValue === "at_least" && total < this.thresholdValue) {
      return `Quotation total must be at least ${this.formatMoney(this.thresholdValue)} MWK for this route.`
    }
    if (this.capRuleValue === "less_than" && total >= this.thresholdValue) {
      return `Single quotation total must be less than ${this.formatMoney(this.thresholdValue)} MWK.`
    }
    if (this.capRuleValue === "between" && (total < this.thresholdValue || total >= this.upperThresholdValue)) {
      return `Multiple quotation total must be at least ${this.formatMoney(this.thresholdValue)} MWK and less than ${this.formatMoney(this.upperThresholdValue)} MWK.`
    }

    return ""
  }

  setCapMessage(target, message, total) {
    if (!target) return

    target.textContent = message
    target.classList.toggle("text-danger", message.length > 0)
    target.classList.toggle("text-success", message.length === 0 && total > 0)
  }

  formatMoney(amount) {
    return new Intl.NumberFormat("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(amount)
  }
}

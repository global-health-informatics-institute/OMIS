import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["amount", "error", "submit"];

  connect() {
    this.amountTarget.addEventListener("input", this.validateAmount.bind(this));
  }

  validateAmount() {
    let amount = parseFloat(this.amountTarget.value);
    let limit = 35000;

    if (amount > limit) {
      this.errorTarget.style.display = "block";
      this.submitTarget.disabled = true;
    } else {
      this.errorTarget.style.display = "none";
      this.submitTarget.disabled = false;
    }
  }
}

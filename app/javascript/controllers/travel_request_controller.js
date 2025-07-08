// app/javascript/controllers/travel_request_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["employeeCheckboxList", "travelerNames"]

  updateTravelerNames() {
    // Get all checked checkboxes inside employeeCheckboxList
    const checkedBoxes = this.employeeCheckboxListTarget.querySelectorAll("input[type=checkbox]:checked")

    // Get the labels for each checked checkbox
    const names = Array.from(checkedBoxes).map(checkbox => {
      const label = this.element.querySelector(`label[for='${checkbox.id}']`)
      return label ? label.textContent.trim() : ""
    }).filter(name => name.length > 0)

    // Update the traveler names textarea
    this.travelerNamesTarget.value = names.join(", ")

    // Update the traveler count hidden input
    const countField = document.getElementById("selected_traveler_count")
    if (countField) {
      countField.value = checkedBoxes.length

      // Dispatch an 'input' event to trigger JS re-calculations (e.g., allowance)
      countField.dispatchEvent(new Event("input", { bubbles: true }))
    }
  }
}

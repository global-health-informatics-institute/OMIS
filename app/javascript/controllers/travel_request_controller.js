import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = [
    "travelRequestForm",
    "budgetDetailsForm",
    "budgetFormModal",
    "employeeCheckboxList"
  ]

  connect() {
    console.log("Travel Request Form Stimulus controller connected!");

    if (this.hasBudgetFormModalTarget) {
      this.budgetFormModalTarget.addEventListener('hidden.bs.modal', this.resetBudgetForm.bind(this));
    }
  }

  disconnect() {
    if (this.hasBudgetFormModalTarget) {
      this.budgetFormModalTarget.removeEventListener('hidden.bs.modal', this.resetBudgetForm.bind(this));
    }
  }

  fillBudgetForm(event) {
    event.preventDefault();
    console.log("Stimulus: Fill Budget Form button clicked!");

    const travelRequestForm = this.travelRequestFormTarget;
    const budgetDetailsForm = this.budgetDetailsFormTarget;

    let allRequiredFieldsFilled = true;
    const requiredInputs = travelRequestForm.querySelectorAll('[required]');

    requiredInputs.forEach(input => {
      input.classList.remove('is-invalid');

      if (input.type === 'checkbox' || input.type === 'radio') {
        if (input.name === 'requisition[employee_ids][]') {
          const checkedEmployees = travelRequestForm.querySelectorAll('input[name="requisition[employee_ids][]"]:checked');
          if (checkedEmployees.length === 0) {
            allRequiredFieldsFilled = false;
          }
        }
      } else if (!input.value || input.value.trim() === '') {
        allRequiredFieldsFilled = false;
        input.classList.add('is-invalid');
      }
    });

    if (!allRequiredFieldsFilled) {
      alert("Please fill in all required fields in the Travel Request Form before proceeding to Budget.");
      return;
    }

    budgetDetailsForm.querySelectorAll('input[type="hidden"][data-from-travel-form]').forEach(hiddenInput => {
      hiddenInput.remove();
    });

    const travelFormData = new FormData(travelRequestForm);

    for (const [name, value] of travelFormData.entries()) {
      const hiddenInput = document.createElement('input');
      hiddenInput.type = 'hidden';
      hiddenInput.name = name;
      hiddenInput.value = value;
      hiddenInput.setAttribute('data-from-travel-form', 'true');
      budgetDetailsForm.appendChild(hiddenInput);
    }

    const myModal = new Modal(this.budgetFormModalTarget);
    myModal.show();
    console.log("Stimulus: Bootstrap modal should be showing.");
  }

  resetBudgetForm() {
    console.log("Stimulus: Budget modal hidden, clearing dynamic fields.");
    if (this.hasBudgetDetailsFormTarget) {
      this.budgetDetailsFormTarget.reset();
      this.budgetDetailsFormTarget.querySelectorAll('input[type="hidden"][data-from-travel-form]').forEach(hiddenInput => {
        hiddenInput.remove();
      });
    }
  }

  // 👇👇 NEW: Filter checkboxes by search input
  filterEmployees(event) {
    const query = event.target.value.toLowerCase();
    const checkboxes = this.employeeCheckboxListTarget.querySelectorAll(".form-check");

    checkboxes.forEach(cb => {
      const label = cb.querySelector("label").innerText.toLowerCase();
      cb.style.display = label.includes(query) ? "block" : "none";
    });
  }
}

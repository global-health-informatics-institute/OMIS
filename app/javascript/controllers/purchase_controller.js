import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton"]

  connect() {
    this.tabs = Array.from(document.querySelectorAll('.nav-link'))
    this.panels = Array.from(document.querySelectorAll('.tab-pane'))
    this.currentStep = 0
    this.updateSteps()
  }

  nextStep() {
    if (this.currentStep < this.tabs.length - 1) {
      this.currentStep++
      this.updateSteps()
    }
  }

  previousStep() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.updateSteps()
    }
  }

  updateSteps() {
    this.tabs.forEach((tab, index) => {
      tab.classList.toggle('active', index === this.currentStep)
    })

    this.panels.forEach((panel, index) => {
      panel.classList.toggle('show', index === this.currentStep)
      panel.classList.toggle('active', index === this.currentStep)
    })

    // Show submit only on last step
    if (this.currentStep === this.tabs.length - 1) {
      this.submitButtonTarget.classList.remove('d-none')
    } else {
      this.submitButtonTarget.classList.add('d-none')
    }
  }
}

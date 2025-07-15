import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton"]

  connect() {
    this.tabs = Array.from(document.querySelectorAll('.nav-link'))

    // IPC logic: rearrange steps if IPC is required
    const requiresIPC = document.querySelector("#ipcRequirement")?.value === "true"
    
    if (requiresIPC) {
      this.reorderPanelsForIPC()
    }

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

    if (this.currentStep === this.tabs.length - 1) {
      this.submitButtonTarget.classList.remove('d-none')
    } else {
      this.submitButtonTarget.classList.add('d-none')
    }
  }

  reorderPanelsForIPC() {
    const stepContainer = document.querySelector('#nav-tabContent')
    const requestPayment = document.querySelector('#nav-step1')
    const confirmDelivery = document.querySelector('#nav-step2')
    const proofOfPayment = document.querySelector('#nav-step3')
    const assetRegistration = document.querySelector('#nav-step4')

    // Remove old order
    stepContainer.innerHTML = ""

    // Append new order
    stepContainer.appendChild(requestPayment)
    stepContainer.appendChild(confirmDelivery)
    stepContainer.appendChild(proofOfPayment)
    stepContainer.appendChild(assetRegistration)
  }
}

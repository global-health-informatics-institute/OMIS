import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton"]

  connect() {
    this.tabs = Array.from(document.querySelectorAll('.nav-link'))

    window.addEventListener("ipc:changed", (event) => {
  const requiresIPC = event.detail.value
  this.reorderPanels(requiresIPC)
})

// Initial value check
const ipcHidden = document.querySelector("#ipcRequirement")
if (ipcHidden && ipcHidden.value) {
  this.reorderPanels(ipcHidden.value === "true")
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

  reorderPanels(requiresIPC) {
  const stepContainer = document.querySelector('#nav-tabContent')

  const step1 = document.querySelector('#nav-step1') // request_purchase
  const underIPC = document.querySelector('#nav-step2') // under_ipc
  const requestPayment = document.querySelector('#nav-step3')
  const confirmDelivery = document.querySelector('#nav-step4')
  const proofOfPayment = document.querySelector('#nav-step5')
  const assetRegistration = document.querySelector('#nav-step6')

  // Capture current panel
  const currentPanelId = this.panels[this.currentStep]?.id

  // Clear container
  stepContainer.innerHTML = ""

  // Reorder based on IPC selection
  if (requiresIPC) {
    stepContainer.appendChild(step1)           // Step 1: request_purchase
    stepContainer.appendChild(requestPayment)  // Step 2: request_payment
    stepContainer.appendChild(confirmDelivery) // Step 3: confirm_delivery
    stepContainer.appendChild(proofOfPayment)  // Step 4: proof_of_payment
    stepContainer.appendChild(assetRegistration) // Step 5: asset_registration
  } else {
    stepContainer.appendChild(step1)     // Step 1: request_purchase
    stepContainer.appendChild(underIPC)  // Step 2: under_ipc
  }

  // Update step list
  this.panels = Array.from(document.querySelectorAll('.tab-pane'))
  this.tabs = Array.from(document.querySelectorAll('.nav-link'))

  // Try to preserve step or fallback
  const newIndex = this.panels.findIndex(p => p.id === currentPanelId)
  this.currentStep = newIndex >= 0 ? newIndex : 0

  this.updateSteps()
}
}

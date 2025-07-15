import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "nextButton", "previousButton"]
  static values = {
    currentStep: { type: Number, default: 0 },
    requiresIpc: { type: Boolean, default: false }
  }

  connect() {
    this.panels = Array.from(this.element.querySelectorAll('.tab-pane'))
    this.setupIPCListeners()
    this.updateStepVisibility()
  }

  setupIPCListeners() {
    // Listen for IPC selection changes from under_ipc form
    document.addEventListener('ipc:changed', (event) => {
      this.requiresIpcValue = event.detail.requiresIpc
      this.reorderSteps()
    })
  }

  nextStep() {
    if (this.currentStepValue < this.panels.length - 1) {
      this.currentStepValue++
      this.updateStepVisibility()
    }
  }

  previousStep() {
    if (this.currentStepValue > 0) {
      this.currentStepValue--
      this.updateStepVisibility()
    }
  }

  updateStepVisibility() {
    // Hide all panels
    this.panels.forEach(panel => {
      panel.classList.remove('show', 'active')
    })

    // Show current panel
    const currentPanel = this.panels[this.currentStepValue]
    if (currentPanel) {
      currentPanel.classList.add('show', 'active')
    }

    // Update button states
    this.updateButtonStates()
  }

  updateButtonStates() {
    const isLastStep = this.currentStepValue === this.panels.length - 1
    const isNonIpcFlow = !this.requiresIpcValue && this.currentStepValue >= 1

    this.submitButtonTarget.classList.toggle('d-none', !isLastStep)
    this.nextButtonTarget.classList.toggle('d-none', isLastStep || isNonIpcFlow)
    this.previousButtonTarget.classList.toggle('d-none', this.currentStepValue === 0 || isNonIpcFlow)
  }

  reorderSteps() {
    const stepContainer = document.getElementById('nav-tabContent')
    const currentPanelId = this.panels[this.currentStepValue]?.id

    // Get all panels
    const step1 = document.getElementById('nav-step1') // request_purchase
    const underIpc = document.getElementById('nav-step2') // under_ipc
    const requestPayment = document.getElementById('nav-step3')
    const proofOfPayment = document.getElementById('nav-step4')
    const confirmDelivery = document.getElementById('nav-step5')
    const assetRegistration = document.getElementById('nav-step6')

    // Clear container
    stepContainer.innerHTML = ""

    if (this.requiresIpcValue) {
      // IPC Flow Order:
      // 1. request_purchase
      // 2. payment_request_form
      // 3. confirm_delivery_form
      // 4. proof_of_payment
      // 5. asset_registration_form
      stepContainer.append(step1, requestPayment, confirmDelivery, proofOfPayment, assetRegistration)
    } else {
      // Non-IPC Flow Order:
      // 1. request_purchase
      // 2. under_ipc
      stepContainer.append(step1, underIpc)
    }

    // Update panels reference
    this.panels = Array.from(stepContainer.querySelectorAll('.tab-pane'))

    // Try to maintain current position or reset to step 0
    const newIndex = this.panels.findIndex(panel => panel.id === currentPanelId)
    this.currentStepValue = newIndex >= 0 ? newIndex : 0

    this.updateStepVisibility()
  }
}
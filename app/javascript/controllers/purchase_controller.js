import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "nextButton", "previousButton"]
  static values = {
    currentStep: { type: Number, default: 0 },
    requiresIpc: { type: Boolean, default: false }
  }

  connect() {
    this.allPanels = Array.from(document.getElementById('nav-tabContent').querySelectorAll('.tab-pane'))
    this.visiblePanels = [...this.allPanels] // Track visible panels separately
    this.setupIPCListeners()
    this.setupNavigationListeners()
    this.reorderSteps() // Initial ordering
    this.updateStepVisibility()
  }

  setupIPCListeners() {
    document.addEventListener('ipc:changed', (event) => {
      this.handleIpcChange(event.detail.requiresIpc)
    })
  }

  handleIpcChange(requiresIpc) {
    const currentPanelId = this.visiblePanels[this.currentStepValue]?.id
    
    this.requiresIpcValue = requiresIpc
    this.reorderSteps()
    
    // Find current panel in new order
    if (currentPanelId) {
      const newIndex = this.visiblePanels.findIndex(panel => panel.id === currentPanelId)
      this.currentStepValue = newIndex >= 0 ? newIndex : 0
    } else {
      this.currentStepValue = 0
    }
    
    this.updateStepVisibility()
  }

  reorderSteps() {
    const stepContainer = document.getElementById('nav-tabContent')
    const panelsToReorder = [...this.allPanels]

    // Clear only panels from container
    this.allPanels.forEach(panel => panel.remove())

    // Always include first step
    const firstStep = panelsToReorder.find(p => p.id === 'nav-step1')
    if (firstStep) {
      stepContainer.appendChild(firstStep)
      this.visiblePanels = [firstStep]
    }

    if (this.requiresIpcValue) {
      // IPC Flow Order
      const ipcOrder = [
        'nav-step3',  // payment_request_form
        'nav-step5',  // confirm_delivery_form
        'nav-step4',  // proof_of_payment
        'nav-step6'   // asset_registration_form
      ]
      
      ipcOrder.forEach(id => {
        const panel = panelsToReorder.find(p => p.id === id)
        if (panel) {
          stepContainer.appendChild(panel)
          this.visiblePanels.push(panel)
        }
      })
    } else {
      // Non-IPC Flow
      const underIpc = panelsToReorder.find(p => p.id === 'nav-step2')
      if (underIpc) {
        stepContainer.appendChild(underIpc)
        this.visiblePanels.push(underIpc)
      }
    }
  }

  nextStep() {
    if (this.currentStepValue < this.visiblePanels.length - 1) {
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
    this.visiblePanels.forEach((panel, index) => {
      if (index === this.currentStepValue) {
        panel.classList.add('show', 'active')
      } else {
        panel.classList.remove('show', 'active')
      }
    })

    this.updateButtonStates()
  }

  updateButtonStates() {
    const isLastStep = this.currentStepValue === this.visiblePanels.length - 1
    const isFirstStep = this.currentStepValue === 0
    const isNonIpcFlow = !this.requiresIpcValue && this.currentStepValue >= 1

    // Show submit only on last step
    this.submitButtonTarget.classList.toggle('d-none', !isLastStep)
    
    // Show next button except on last step or in non-IPC flow after first step
    this.nextButtonTarget.classList.toggle('d-none', isLastStep || isNonIpcFlow)
    
    // Show previous button except on first step or in non-IPC flow after first step
    this.previousButtonTarget.classList.toggle('d-none', isFirstStep || isNonIpcFlow)
  }
}
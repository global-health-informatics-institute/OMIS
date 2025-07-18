import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "nextButton", "previousButton", "amountField"]
  static values = {
    currentStep: { type: Number, default: 0 },
    requiresIpc: { type: Boolean, default: false },
    threshold: Number
  }

  initialize() {
    console.log("Initializing Purchase controller")
    this.debounceTimer = null
    this.lastIpcState = null
    this.currentAmount = null
  }

  connect() {
    console.log("Purchase controller connected")
    this.allPanels = Array.from(document.getElementById('nav-tabContent').querySelectorAll('.tab-pane'))
    this.visiblePanels = [...this.allPanels]
    this.updateStepVisibility()
    this.setupIPCListeners()
    
    if (this.hasAmountFieldTarget) {
      console.log("Amount field detected, initializing value tracking")
      this.currentAmount = parseFloat(this.amountFieldTarget.value) || 0
      this.checkAmountThreshold({ target: this.amountFieldTarget })
    }
  }

  nextStep(event) {
    console.log("Next step triggered")
    event.preventDefault()
    if (this.currentStepValue < this.visiblePanels.length - 1) {
      console.log(`Moving from step ${this.currentStepValue} to ${this.currentStepValue + 1}`)
      this.currentStepValue++
      this.updateStepVisibility()
    } else {
      console.log("Already at last step")
    }
  }

  previousStep(event) {
    console.log("Previous step triggered")
    event.preventDefault()
    if (this.currentStepValue > 0) {
      console.log(`Moving from step ${this.currentStepValue} to ${this.currentStepValue - 1}`)
      this.currentStepValue--
      this.updateStepVisibility()
    } else {
      console.log("Already at first step")
    }
  }

  setupIPCListeners() {
    console.log("Setting up IPC event listeners...")
    document.addEventListener('ipc:changed', (event) => {
      console.log("Received ipc:changed event with detail:", event.detail)
      this.handleIpcChange(event.detail.requiresIpc)
    })
  }

  checkAmountThreshold(event) {
    console.log("checkAmountThreshold triggered")
    
    if (this.debounceTimer) {
      console.log("Clearing existing debounce timer")
      clearTimeout(this.debounceTimer)
    }

    const target = event.target
    const cursorPosition = target.selectionStart
    const newAmount = parseFloat(target.value) || 0

    console.log(`New amount value: ${newAmount}, previous value: ${this.currentAmount}`)

    if (newAmount === this.currentAmount) {
      console.log("Amount unchanged, skipping processing")
      return
    }

    this.currentAmount = newAmount

    this.debounceTimer = setTimeout(() => {
      console.log("Processing amount after debounce")
      const threshold = this.thresholdValue || parseFloat(target.dataset.threshold)
      console.log(`Current threshold: ${threshold}`)

      if (isNaN(this.currentAmount) || isNaN(threshold)) {
        console.log("Invalid amount or threshold values")
        return
      }

      const requiresIpc = this.currentAmount > threshold
      console.log(`IPC required? ${requiresIpc} (${this.currentAmount} > ${threshold})`)

      if (this.lastIpcState !== requiresIpc) {
        console.log(`IPC state changed from ${this.lastIpcState} to ${requiresIpc}`)
        this.lastIpcState = requiresIpc
        this.requiresIpcValue = requiresIpc
        this.dispatchIpcChanged(requiresIpc)
      } else {
        console.log("IPC state unchanged")
      }

      console.log("Restoring focus to amount field")
      target.focus()
      target.setSelectionRange(cursorPosition, cursorPosition)
    }, 300)

    console.log(`Debounce timer set for 300ms (timer ID: ${this.debounceTimer})`)
  }

  dispatchIpcChanged(requiresIpc) {
    console.log("Dispatching ipc:changed event")
    const event = new CustomEvent("ipc:changed", {
      detail: { requiresIpc },
      bubbles: true
    })
    console.log("Event details:", event.detail)
    document.dispatchEvent(event)
  }

  handleIpcChange(requiresIpc) {
    console.log("Handling IPC change. Requires IPC?", requiresIpc)

    const currentPanelId = this.visiblePanels[this.currentStepValue]?.id
    console.log("Current panel before reorder:", currentPanelId)

    this.requiresIpcValue = requiresIpc
    this.reorderSteps()

    const newIndex = this.visiblePanels.findIndex(panel => panel.id === currentPanelId)
    console.log("New index of current panel after reorder:", newIndex)

    this.currentStepValue = newIndex >= 0 ? newIndex : 0
    console.log("Setting currentStepValue to:", this.currentStepValue)
    this.updateStepVisibility()
  }

  reorderSteps() {
    console.log("Reordering steps based on requiresIpc:", this.requiresIpcValue)

    const stepContainer = document.getElementById('nav-tabContent')
    const panelsToReorder = [...this.allPanels]

    console.log("Removing all panels from DOM")
    this.allPanels.forEach(panel => panel.remove())

    const firstStep = panelsToReorder.find(p => p.id === 'nav-step1')
    if (firstStep) {
      console.log("Appending first step (nav-step1)")
      stepContainer.appendChild(firstStep)
      this.visiblePanels = [firstStep]
    }

    const ipcOrder = ['nav-step3', 'nav-step5', 'nav-step4', 'nav-step6']
    const nonIpcOrder = ['nav-step3', 'nav-step4', 'nav-step5', 'nav-step6']

    const orderToUse = this.requiresIpcValue ? ipcOrder : nonIpcOrder
    console.log("Using step order:", orderToUse)

    orderToUse.forEach(id => {
      const panel = panelsToReorder.find(p => p.id === id)
      if (panel) {
        console.log("Appending panel:", id)
        stepContainer.appendChild(panel)
        this.visiblePanels.push(panel)
      } else {
        console.warn("Panel not found for id:", id)
      }
    })

    console.log("Final visiblePanels order:", this.visiblePanels.map(p => p.id))
  }

  updateStepVisibility() {
    console.log("Updating step visibility")
    
    this.visiblePanels.forEach((panel, index) => {
      const isActive = index === this.currentStepValue
      console.log(`Panel ${panel.id} - show: ${isActive}, active: ${isActive}`)
      panel.classList.toggle("show", isActive)
      panel.classList.toggle("active", isActive)
    })

    console.log(`Visible step: ${this.currentStepValue + 1}/${this.visiblePanels.length}`)

    if (this.submitButtonTarget) {
      const isLastStep = this.currentStepValue === this.visiblePanels.length - 1
      console.log(`Submit button - isLastStep: ${isLastStep}`)
      
      if (isLastStep) {
        this.submitButtonTarget.classList.remove('d-none')
        if (this.nextButtonTarget) {
          this.nextButtonTarget.classList.add('d-none')
        }
      } else {
        this.submitButtonTarget.classList.add('d-none')
        if (this.nextButtonTarget) {
          this.nextButtonTarget.classList.remove('d-none')
        }
      }
    }

    if (this.previousButtonTarget) {
      const isFirstStep = this.currentStepValue === 0
      console.log(`Previous button - disabled: ${isFirstStep}`)
      this.previousButtonTarget.disabled = isFirstStep
    }
    
    if (this.nextButtonTarget) {
      const isLastStep = this.currentStepValue === this.visiblePanels.length - 1
      console.log(`Next button - disabled: ${isLastStep}`)
      this.nextButtonTarget.disabled = isLastStep
    }
  }
}
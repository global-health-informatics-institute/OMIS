import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "nextButton", "previousButton", "amountField"]
  static values = {
    currentStep: { type: Number, default: 0 },
    requiresIpc: { type: Boolean, default: false },
    threshold: Number,
    requisitionId: Number,
    // Add a new value to store the current state from the backend
    currentState: String
  }

  initialize() {
    console.log("Initializing Purchase controller")
    this.debounceTimer = null
    this.lastIpcState = null
    this.currentAmount = null
    this.initialized = false
  }

  async connect() {
    console.log("Purchase controller connected")
    console.log("Initial currentState value:", this.currentStateValue) 
    // Initialize panels
    this.allPanels = Array.from(document.getElementById('nav-tabContent').querySelectorAll('.tab-pane'))
    this.visiblePanels = [...this.allPanels]
    
    // Set up listeners
    this.setupIPCListeners()
    
    // Process initial state with database fallback
    await this.processInitialState()
    
    this.initialized = true
    console.log("Controller fully initialized")
    
    // Initial update of button visibility based on the current state
    this.updateButtonVisibility();
  }

  async processInitialState() {
    console.log("Processing initial state")
    
    // First try to get amount from input field
    if (this.hasAmountFieldTarget) {
      console.log("Amount field found - checking initial value")
      const initialAmount = parseFloat(this.amountFieldTarget.value) || 0
      console.log(`Initial amount value: ${initialAmount}`)
      this.currentAmount = initialAmount
    } 
    // Fallback to database if no amount field
    else if (this.requisitionIdValue) {
      console.log("No amount field found - fetching from database")
      try {
        const response = await fetch(`/requisitions/${this.requisitionIdValue}/amount`)
        if (!response.ok) throw new Error("Failed to fetch amount")
        const data = await response.json()
        this.currentAmount = parseFloat(data.amount) || 0
        console.log(`Retrieved amount from DB: ${this.currentAmount}`)
      } catch (error) {
        console.error("Error fetching amount:", error)
        this.currentAmount = 0
      }
    } else {
      console.log("No amount field or requisition ID - using default")
      this.currentAmount = 0
    }
    
    this.processAmountChange(this.currentAmount)
  }

  checkAmountThreshold(event) {
    console.log("Amount threshold check triggered")
    
    if (this.debounceTimer) {
      console.log("Clearing existing debounce timer")
      clearTimeout(this.debounceTimer)
    }

    const target = event.target
    const cursorPosition = target.selectionStart
    const newAmount = parseFloat(target.value) || 0

    console.log(`New amount value: ${newAmount}, previous value: ${this.currentAmount}`)

    this.currentAmount = newAmount

    this.debounceTimer = setTimeout(() => {
      console.log("Processing amount after debounce")
      this.processAmountChange(target.value)
      
      // Restore focus and cursor position
      if (document.activeElement === target) {
        console.log("Restoring focus to amount field")
        target.focus()
        target.setSelectionRange(cursorPosition, cursorPosition)
      }
    }, 300)

    console.log(`Debounce timer set for 300ms (timer ID: ${this.debounceTimer})`)
  }

  processAmountChange(amountValue) {
    console.log("Processing amount change:", amountValue)
    
    const amount = parseFloat(amountValue) || 0
    const threshold = this.thresholdValue || parseFloat(this.amountFieldTarget?.dataset.threshold) || 0
    
    console.log(`Current amount: ${amount}, Threshold: ${threshold}`)

    if (isNaN(amount)) {
      console.log("Invalid amount value")
      return
    }

    const requiresIpc = amount > threshold
    console.log(`IPC required? ${requiresIpc} (${amount} > ${threshold})`)

    if (!this.initialized || this.lastIpcState !== requiresIpc) {
      console.log(`IPC state changed from ${this.lastIpcState} to ${requiresIpc}`)
      this.lastIpcState = requiresIpc
      this.requiresIpcValue = requiresIpc
      this.dispatchIpcChanged(requiresIpc)
    } else {
      console.log("IPC state unchanged")
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
    while (stepContainer.firstChild) {
    stepContainer.removeChild(stepContainer.firstChild)
    }


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

    // The submit button logic remains the same
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

    // Call the new method to update next/previous button visibility
    this.updateButtonVisibility();
  }

  // New method to control the visibility of next and previous buttons
  updateButtonVisibility() {
    console.log("Updating Next and Previous button visibility based on current state.");
    const shouldShowButtons = this.currentStateValue === "Pending Payment Request";
    console.log("Current state value is:", this.currentStateValue, "Should show buttons?", this.currentStateValue === "Pending Payment Request")


    if (this.nextButtonTarget) {
      if (shouldShowButtons && this.currentStepValue < this.visiblePanels.length - 1) {
        this.nextButtonTarget.classList.remove('d-none');
        this.nextButtonTarget.disabled = false; // Ensure it's not disabled if visible
      } else {
        this.nextButtonTarget.classList.add('d-none');
      }
    }

    if (this.previousButtonTarget) {
      if (shouldShowButtons && this.currentStepValue > 0) {
        this.previousButtonTarget.classList.remove('d-none');
        this.previousButtonTarget.disabled = false; // Ensure it's not disabled if visible
      } else {
        this.previousButtonTarget.classList.add('d-none');
      }
    }
    
    // Disable next/previous buttons if they are shown but at the start/end
    if (this.nextButtonTarget && shouldShowButtons) {
      this.nextButtonTarget.disabled = this.currentStepValue === this.visiblePanels.length - 1;
    }
    if (this.previousButtonTarget && shouldShowButtons) {
      this.previousButtonTarget.disabled = this.currentStepValue === 0;
    }
  }
}
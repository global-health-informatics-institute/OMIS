import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"



export default class extends Controller {
  static targets = ["submitButton", "nextButton", "previousButton", "amountField", "assetButton", "ipcConfirmationModal","employeeSearch",
  "employeeCheckboxList","ipcMeetingTime","selectedEmployeesDisplay","requestIpcButton",
  "ipcMeetingDate"]
  static values = {
    currentStep: { type: Number, default: 0 },
    requiresIpc: { type: Boolean, default: false },
    threshold: Number,
    requisitionId: Number,
    currentState: String,
    designationId: Number
  }
  filterEmployees(event) {
  const searchTerm = event.target.value.toLowerCase();
  const checkboxes = this.employeeCheckboxListTarget.querySelectorAll('.form-check');

  checkboxes.forEach(div => {
    const label = div.querySelector('label').textContent.toLowerCase();
    if (label.includes(searchTerm)) {
      div.style.display = "";
    } else {
      div.style.display = "none";
    }
  });
}
//populate the selected employees
updateSelectedEmployees() {
  if (!this.hasSelectedEmployeesDisplayTarget) {
    console.warn("selectedEmployeesDisplayTarget not found.");
    return;
  }

  const checkboxes = this.employeeCheckboxListTarget.querySelectorAll("input[type='checkbox']:checked");
  const names = Array.from(checkboxes).map(cb => cb.dataset.employeeName).filter(Boolean);

  this.selectedEmployeesDisplayTarget.value = names.join(", ");
}


//Initiate email sending when continue button is triggered
continueWithIpc() {
  console.log("Continue with IPC clicked");
    event.preventDefault();  
  // 1. Get selected employee IDs
  const selectedIds = Array.from(this.employeeCheckboxListTarget.querySelectorAll("input[type='checkbox']:checked"))
    .map(cb => cb.value);
  console.log("Selected Employee IDs:", selectedIds);

  // 2. Get meeting date
  const date = this.ipcMeetingDateTarget.value;
  console.log("Meeting Date:", date);
  const time = this.ipcMeetingTimeTarget.value;

  if (selectedIds.length === 0 || !date || !time) {
    alert("Please select at least one committee member and choose a meeting date and time.");
    return;
  }

  // 3. Send data to the server
  fetch(`/requisitions/${this.requisitionIdValue}/schedule_ipc_meeting`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({
      employee_ids: selectedIds,
      meeting_date: date,
      meeting_time: time
    })
  })
  .then(response => {
    if (!response.ok) throw new Error("Failed to send IPC notification.");
    return response.json();
  })
  .then(data => {
    console.log("Server response:", data);
    this.dispatchIpcChanged(true); // proceed with IPC steps
    this.showStyledAlert(data.message || "Emails sent successfully. All selected IPC members have been notified.", "success");
    this.ipcModalInstance.hide();
    setTimeout(() => {
    window.location.href = data.redirect_url;
  }, 1000);
  })
  .catch(error => {
    console.error("IPC submission error:", error);
    alert("An error occurred while sending IPC details.");
  });
}

showStyledAlert(message, type = 'success') {
  const container = document.getElementById('custom-alert-container');
  if (!container) return;

  const alertDiv = document.createElement('div');
  alertDiv.textContent = message;

  alertDiv.style.backgroundColor = type === 'success' ? '#4CAF50' : '#f44336'; // green or red
  alertDiv.style.color = 'white';
  alertDiv.style.padding = '15px 25px';
  alertDiv.style.marginBottom = '10px';
  alertDiv.style.borderRadius = '5px';
  alertDiv.style.boxShadow = '0 2px 8px rgba(0,0,0,0.2)';
  alertDiv.style.fontSize = '16px';
  alertDiv.style.fontWeight = 'bold';
  alertDiv.style.cursor = 'pointer';
  alertDiv.style.opacity = '1';
  alertDiv.style.transition = 'opacity 0.5s ease';

  alertDiv.onclick = () => container.removeChild(alertDiv);

  container.appendChild(alertDiv);

  setTimeout(() => {
    alertDiv.style.opacity = '0';
    setTimeout(() => {
      if (alertDiv.parentNode === container) container.removeChild(alertDiv);
    }, 500);
  }, 4000);
}


  goToAssetRegistration() {
  console.log("Navigating to Asset Registration step");

  const assetPanel = this.visiblePanels.find(panel => panel.id === "nav-step6");
  if (assetPanel) {
    const index = this.visiblePanels.indexOf(assetPanel);
    if (index !== -1) {
      this.currentStepValue = index;
      this.updateStepVisibility();
    } else {
      console.warn("Asset Registration panel not found in visiblePanels");
    }
  } else {
    console.warn("nav-step6 not found in visiblePanels");
  }
}
  // Add this method to your controller
goToStep1() {
  console.log("Going back to Step 1");
  
  // Find step 1 in visible panels
  const step1Panel = this.visiblePanels.find(panel => panel.id === 'nav-step1');
  
  if (step1Panel) {
    // Update current step to 0 (first step)
    this.currentStepValue = 0;
    
    // Update UI
    this.updateStepVisibility();
    
    // Scroll to top for better UX
    window.scrollTo({ top: 0, behavior: 'smooth' });
  } else {
    console.warn("Step 1 panel not found in visible panels");
  }
}

  initialize() {
    console.log("Initializing Purchase controller")
    this.debounceTimer = null
    this.lastIpcState = null
    this.currentAmount = null
    this.initialized = false
    this.ipcModalInstance = null
  }

  async connect() {
    console.log("Purchase controller connected")
    console.log("Initial currentState value:", this.currentStateValue)
    console.log("Has IPC modal target?", this.hasIpcConfirmationModalTarget);
    console.log("IPC modal target:", this.ipcConfirmationModalTarget);
     console.log("Designation ID value:", this.designationIdValue); 
    // Initialize panels
    this.allPanels = Array.from(document.getElementById('nav-tabContent').querySelectorAll('.tab-pane'))
    this.visiblePanels = [...this.allPanels]
    
    // Set up listeners
    this.setupIPCListeners()
    // Process initial state with database fallback
    await this.processInitialState()
     this.reorderSteps();    
    this.initialized = true
    console.log("Controller fully initialized")
    if (this.hasIpcConfirmationModalTarget) {
      this.ipcModalInstance = new bootstrap.Modal(this.ipcConfirmationModalTarget);
      console.log("IPC Confirmation Modal initialized.");
    }
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
  
  // Remove commas before parsing
  const numericValue = target.value.replace(/[^\d]/g, '')
  const newAmount = parseFloat(numericValue) || 0

  console.log(`New amount value: ${newAmount}, previous value: ${this.currentAmount}`)

  this.currentAmount = newAmount

  this.debounceTimer = setTimeout(() => {
    console.log("Processing amount after debounce")
    this.processAmountChange(newAmount)
    
    // Restore focus and cursor position
    if (document.activeElement === target) {
      console.log("Restoring focus to amount field")
      target.focus()
      target.setSelectionRange(cursorPosition, cursorPosition)
    }
  }, 300)

  console.log(`Debounce timer set for 300ms (timer ID: ${this.debounceTimer})`)
}
  showIpcConfirmationModal() {
  console.log("Showing IPC confirmation modal.");
  if (this.ipcModalInstance) {
    this.ipcModalInstance.show();
  } else {
    console.warn("IPC modal instance not initialized.");
  }
}

processAmountChange(amountValue) {
  console.log("Processing amount change:", amountValue)

  //  ONLY proceed if current state is Pending Payment Request
  if (this.currentStateValue !== "Pending Payment Request") {
    console.log("Skipping check — current state is not 'Pending Payment Request'")
    return
  }

  const amount = parseFloat(amountValue) || 0
  const threshold = this.thresholdValue || parseFloat(this.amountFieldTarget?.dataset.threshold) || 0

  console.log(`Current amount: ${amount}, Threshold: ${threshold}`)

  if (isNaN(amount)) {
    console.log("Invalid amount value")
    return
  }

  const requiresIpc = amount > threshold
  console.log(`IPC required? ${requiresIpc}`)

  // --- UI feedback ---
  const parent = this.amountFieldTarget.parentElement
  const existingError = parent.querySelector(".invalid-feedback.dynamic")
  if (existingError) existingError.remove()

  if (requiresIpc) {
    this.amountFieldTarget.classList.add("is-invalid")

    const errorMessage = document.createElement("div")
    errorMessage.className = "invalid-feedback d-block dynamic"
    errorMessage.innerText = `Amount exceeds the threshold (MWK${threshold.toFixed(2)}). Please Request IPC to proceed with the procurement.`

    parent.appendChild(errorMessage)
  } else {
    this.amountFieldTarget.classList.remove("is-invalid")
  }

  // --- Step reordering logic ---
  if (this.lastIpcState !== requiresIpc) {
    this.lastIpcState = requiresIpc

    if (requiresIpc && this.initialized) {
      console.log("Amount exceeds threshold, showing IPC modal or altering steps.")
      this.requiresIpcValue = true
      this.dispatchIpcChanged(true)
    } else {
      console.log("Amount within threshold, proceeding without IPC.")
      this.requiresIpcValue = false
      this.dispatchIpcChanged(false)
    }
  } else {
    console.log("No change in IPC state — not dispatching.")
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
  console.log("Reordering steps based on requiresIpc and currentStateValue");

  const stepContainer = document.getElementById('nav-tabContent');
  const panelsToReorder = [...this.allPanels];
  console.log("currentStepValue:", this.currentStepValue);
  console.log("visiblePanels:", this.visiblePanels.map(p => p.id));

  // Clear the container
  while (stepContainer.firstChild) {
    stepContainer.removeChild(stepContainer.firstChild);
  }
  this.visiblePanels = [];

  // Conditionally include step 1 based on the updated shouldShowStep1()
  if (this.shouldShowStep1()) {
    const firstStep = panelsToReorder.find(p => p.id === 'nav-step1');
    if (firstStep) {
      console.log("Appending step 1 (nav-step1)");
      stepContainer.appendChild(firstStep);
      this.visiblePanels = [firstStep];
    } else {
      this.visiblePanels = [];
    }
  } else {
    this.visiblePanels = [];
  }

  let orderToUse;

  if (["Pending Payment Request", "LPO Accepted"].includes(this.currentStateValue)) {
    orderToUse = ['nav-step3'];

  }else if (this.currentStateValue === "Payment Requested" && this.designationIdValue === 5) {
  orderToUse = ['nav-step1'];
  }
	else if (this.currentStateValue === "Payment Requested") {
    orderToUse = ['nav-step5'];
  } else if (this.currentStateValue === "Funds Approved") {
    orderToUse = ['nav-step5', 'nav-step4'];
  } else if (this.requiresIpcValue) {
    orderToUse = ['nav-step3', 'nav-step5', 'nav-step4', 'nav-step6'];
  } else {
    orderToUse = ['nav-step3', 'nav-step4', 'nav-step5', 'nav-step6'];
  }

  console.log("Using step order:", orderToUse);

  orderToUse.forEach(id => {
    const panel = panelsToReorder.find(p => p.id === id);
    if (panel) {
      console.log("Appending panel:", id);
      stepContainer.appendChild(panel);
      this.visiblePanels.push(panel);
    } else {
      console.warn("Panel not found for id:", id);
    }
  });

  console.log("Final visiblePanels order:", this.visiblePanels.map(p => p.id));

  // After reordering, if the current step is now out of bounds, reset it to 0
  if (this.currentStepValue >= this.visiblePanels.length) {
    this.currentStepValue = 0;
  }
  this.updateStepVisibility(); // Ensure UI updates after reordering
}
shouldShowStep51() {
  return this.currentStateValue !== "Pending Payment Request" && this.currentStateValue !== "LPO Accepted";
}
shouldShowStep1() {
  return !["Pending Payment Request", "LPO Accepted", "Payment Requested"].includes(this.currentStateValue);
}
  
updateStepVisibility() {
    console.log("Updating step visibility");

    this.visiblePanels.forEach((panel, index) => {
      const isActive = index === this.currentStepValue;
      panel.classList.toggle("show", isActive);
      panel.classList.toggle("active", isActive);
    });

    console.log(`Visible step: ${this.currentStepValue + 1}/${this.visiblePanels.length}`);

    if (this.submitButtonTarget) {
      const isLastStep = this.currentStepValue === this.visiblePanels.length - 1;

      // Always hide the submit button
      this.submitButtonTarget.classList.add('d-none');
    }

    // Now handle the next button visibility
    if (this.nextButtonTarget) {
      const isLastStep = this.currentStepValue === this.visiblePanels.length - 1;
      if (isLastStep) {
        // Hide the next button on the last step
        this.nextButtonTarget.classList.add('d-none');
      } else {
        // Show the next button on all other steps
        this.nextButtonTarget.classList.remove('d-none');
      }
    }

    this.updateButtonVisibility();
  }

  // New method to control the visibility of next and previous buttons
 updateButtonVisibility() {
  console.log("Updating Next and Previous button visibility based on current state.");
  const shouldShowButtons = ["Pending Payment Request","Payment Requested", "Funds Approved","LPO Accepted"].includes(this.currentStateValue);
  const isAuthorized = this.designationIdValue === 12;

  if (this.nextButtonTarget) {
    if (shouldShowButtons && isAuthorized && this.currentStepValue < this.visiblePanels.length - 1) {
      this.nextButtonTarget.classList.remove('d-none');
      this.nextButtonTarget.disabled = false;
    } else {
      this.nextButtonTarget.classList.add('d-none');
    }
  }

  if (this.previousButtonTarget) {
    if (shouldShowButtons && this.currentStepValue > 0) {
      this.previousButtonTarget.classList.remove('d-none');
      this.previousButtonTarget.disabled = false;
    } else {
      this.previousButtonTarget.classList.add('d-none');
    }
  }

  //  Show Asset Registration button only if current state is "Item accepted"
  if (this.hasAssetButtonTarget) {
	  const isAuthorized = this.designationIdValue === 12;
    if (this.currentStateValue === "Item Accepted" && isAuthorized) {
      this.assetButtonTarget.classList.remove("d-none");
    } else {
      this.assetButtonTarget.classList.add("d-none");
    }
  }
   // Request IPC button visibility — only for designation 12
  if (this.hasRequestIpcButtonTarget) {
    if (isAuthorized && this.currentStateValue ==="Pending Payment Request") {
      this.requestIpcButtonTarget.classList.remove('d-none');
    } else {
      this.requestIpcButtonTarget.classList.add('d-none');
    }
  }
  //  Optional: Disable next/prev if needed
  if (this.nextButtonTarget && shouldShowButtons) {
    this.nextButtonTarget.disabled = this.currentStepValue === this.visiblePanels.length - 1;
  }
  if (this.previousButtonTarget && shouldShowButtons) {
    this.previousButtonTarget.disabled = this.currentStepValue === 0;
  }
}
// format the amount

formatNumber(event) {
  const input = event.target;
  // Get cursor position before any changes
  const cursorPosition = input.selectionStart;
  
  // Remove all non-digit characters
  let value = input.value.replace(/[^\d]/g, '');
  
  // Convert to number
  const numberValue = parseInt(value, 10);
  
  if (!isNaN(numberValue)) {
    // Format with commas
    const formattedValue = numberValue.toLocaleString();
    
    // Update the input value
    input.value = formattedValue;
    
    // Calculate new cursor position
    const commaCountBefore = input.value.substring(0, cursorPosition).match(/,/g)?.length || 0;
    const newCursorPosition = cursorPosition + (input.value.substring(0, cursorPosition).match(/,/g)?.length || 0) - commaCountBefore;
    
    // Restore cursor position
    input.setSelectionRange(newCursorPosition, newCursorPosition);
  } else {
    input.value = '';
  }
  
  // Trigger the amount threshold check
  this.checkAmountThreshold(event);
  }
  prepareFormSubmission(event) {
  // Prevent immediate submission so we can clean the amount first
  event.preventDefault();
  
  // Only process if we have an amount field
  if (this.hasAmountFieldTarget) {
    // Remove all non-digit characters (including commas)
    const numericValue = this.amountFieldTarget.value.replace(/[^\d]/g, '');
    
    // Update the field value (now without commas)
    this.amountFieldTarget.value = numericValue;
  }
  
  // Programmatically submit the form after cleaning the value
  this.element.submit();
  
  // Re-enable the button if the submission fails
  event.target.disabled = false;
}
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "message"]

  connect() {
    this.currentStep = 0
    this.refreshSummary()
  }

  next() {
    if (!this.validateStep(this.currentStep)) return

    if (this.currentStep === 2 && this.levelOfEffortTotal() !== 100) {
      this.showMessage("Levels of effort must total exactly 100%.")
      return
    }

    this.showStep(this.currentStep + 1)
  }

  previous() {
    this.showStep(this.currentStep - 1)
  }

  submit(event) {
    for (let step = 0; step < this.stepCount; step += 1) {
      if (!this.validateStep(step)) {
        event.preventDefault()
        this.showStep(step)
        this.showMessage("Please complete all required fields.")
        return
      }
    }

    if (this.levelOfEffortTotal() !== 100) {
      event.preventDefault()
      this.showStep(2)
      this.showMessage("Levels of effort must total exactly 100%.")
    }
  }

  refreshSummary() {
    this.setSummaryValue("summary-first-name", this.inputValue("person[first_name]"))
    this.setSummaryValue("summary-middle-name", this.inputValue("person[middle_name]"))
    this.setSummaryValue("summary-last-name", this.inputValue("person[last_name]"))
    this.setSummaryValue("summary-birth-date", this.formattedDate("person[birth_date]"))
    this.setSummaryValue("summary-gender", this.selectedText("person[gender]"))
    this.setSummaryValue("summary-marital-status", this.selectedText("person[marital_status]"))
    this.setSummaryValue("summary-primary-phone", this.inputValue("person[primary_phone]"))
    this.setSummaryValue("summary-alt-phone", this.inputValue("person[alt_phone]"))
    this.setSummaryValue("summary-email", this.inputValue("person[email_address]"))
    this.setSummaryValue("summary-official-email", this.inputValue("person[official_email]"))
    this.setSummaryValue("summary-postal-address", this.inputValue("person[postal_address]"))
    this.setSummaryValue("summary-residential-address", this.inputValue("person[residential_address]"))
    this.setSummaryValue("summary-landmark", this.inputValue("person[landmark]"))
    this.setSummaryValue("summary-employment-date", this.formattedDate("employee[employment_date]"))
    this.setSummaryValue("summary-designated-role", this.selectedText("employee[designated_role]"))
    this.setSummaryValue("summary-designated-start-date", this.formattedDate("employee[designation_start_date]"))
    this.setSummaryValue("summary-branch", this.selectedText("employee[branch]"))
    this.setSummaryValue("summary-department", this.selectedText("employee[departments]"))
    this.setSummaryValue("summary-supervisor", this.selectedText("supervision[supervisor]"))
    this.setSummaryValue("summary-started-on", this.formattedDate("supervision[started_on]"))
    this.updateEffortSummary()
  }

  validateStep(step) {
    const pane = this.panes[step]
    if (!pane) return false

    const fields = pane.querySelectorAll("[required], .required-field")
    let firstInvalidField = null

    fields.forEach((field) => {
      const isValid = field.value.trim() !== "" && field.checkValidity()
      field.classList.toggle("is-invalid", !isValid)
      if (!isValid && !firstInvalidField) firstInvalidField = field
    })

    if (firstInvalidField) {
      firstInvalidField.focus()
      this.showMessage("Please complete all required fields.")
      return false
    }

    this.clearMessage()
    return true
  }

  showStep(step) {
    if (step < 0 || step >= this.stepCount) return

    this.currentStep = step
    this.panes.forEach((pane, index) => {
      const active = index === step
      pane.classList.toggle("active", active)
      pane.setAttribute("aria-hidden", String(!active))
      this.tabTargets[index].classList.toggle("active", active)
      this.tabTargets[index].setAttribute("aria-selected", String(active))
    })

    const progress = Math.round((step / (this.stepCount - 1)) * 100)
    const progressBar = this.element.querySelector("#progress-bar")
    progressBar.style.width = `${progress}%`
    progressBar.setAttribute("aria-valuenow", String(progress))
    progressBar.textContent = `${progress}%`
    this.clearMessage()
  }

  get panes() {
    return Array.from(this.element.querySelectorAll(".tab-content .tab-pane"))
  }

  get stepCount() {
    return this.panes.length
  }

  levelOfEffortTotal() {
    return Array.from(this.element.querySelectorAll("[data-level-of-effort-target='effort']"))
      .reduce((total, input) => total + (Number(input.value) || 0), 0)
  }

  inputValue(name) {
    return this.element.querySelector(`[name="${name}"]`)?.value.trim() || ""
  }

  selectedText(name) {
    const select = this.element.querySelector(`select[name="${name}"]`)
    return select?.selectedOptions[0]?.text || ""
  }

  formattedDate(name) {
    const value = this.inputValue(name)
    if (!value) return ""

    const [year, month, day] = value.split("-")
    return `${day}/${month}/${year}`
  }

  setSummaryValue(id, value) {
    const element = this.element.querySelector(`#${id}`)
    if (element) element.textContent = value || "—"
  }

  updateEffortSummary() {
    const summary = this.element.querySelector("#summary-levels-of-effort")
    if (!summary) return

    const rows = Array.from(this.element.querySelectorAll("[data-level-of-effort-target='row']"))
      .map((row) => {
        const project = row.querySelector("[data-level-of-effort-target='project']")
        const effort = row.querySelector("[data-level-of-effort-target='effort']")
        return {
          projectValue: project?.value,
          projectName: project?.selectedOptions[0]?.text,
          effort: effort?.value
        }
      })
      .filter(({ projectValue, effort }) => projectValue && effort)

    summary.replaceChildren()
    if (rows.length === 0) {
      const row = summary.insertRow()
      const cell = row.insertCell()
      cell.colSpan = 2
      cell.className = "text-muted"
      cell.textContent = "No levels of effort added."
      return
    }

    rows.forEach(({ projectName, effort }) => {
      const row = summary.insertRow()
      row.insertCell().textContent = projectName
      row.insertCell().textContent = `${effort}%`
    })
  }

  showMessage(message) {
    this.messageTarget.textContent = message
    this.messageTarget.classList.remove("d-none")
  }

  clearMessage() {
    this.messageTarget.textContent = ""
    this.messageTarget.classList.add("d-none")
  }
}

// app/javascript/controllers/timesheet_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["periodPicker"]
  static values = {
    maxDate: String,
    currentDate: String,
    employeeId: Number,
    timesheetId: Number  // Add this to handle direct timesheet access
  }

  connect() {
    this.setupPeriodPicker()
  }

  setupPeriodPicker() {
    const picker = this.periodPickerTarget
    picker.value = this.currentDateValue
    picker.setAttribute("max", this.maxDateValue)

    picker.addEventListener('change', (event) => {
      this.handleDateChange(event)
    })
  }

  handleDateChange(event) {
    const newDate = event.target.value
    const employeeId = this.employeeIdValue
    
    // Determine the correct URL structure based on whether we have a timesheet ID
    let url
    if (this.timesheetIdValue) {
      // If we have a timesheet ID, use that in the path
      url = `/timesheets/${this.timesheetIdValue}?period=${newDate}`
    } else {
      // Otherwise use the show action with employee_id
      url = `/timesheets/show?period=${newDate}`
    }
    
    // Always include the employee_id if we have one
    if (employeeId) {
      url += `&employee_id=${employeeId}`
    }

    Turbo.visit(url)
  }

  disconnect() {
    this.periodPickerTarget.removeEventListener('change', this.handleDateChange)
  }
}
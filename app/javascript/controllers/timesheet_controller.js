
// app/javascript/controllers/timesheet_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "periodPicker" ] // Declare the target for the input

  connect() {
    console.log("Timesheet controller connected!"); // For debugging
    this.setupPeriodPicker();
    // No need for setTimeout, connect() runs when the element is in the DOM
  }

  setupPeriodPicker() {
    // Access the element using targets
    const picker = this.periodPickerTarget;

    // Set max attribute
    // Note: You cannot directly embed Ruby in .js files loaded via Webpacker/Esbuild.
    // You'll need to pass this value via a data attribute on the HTML element.
    // For now, let's assume `Date.today.end_of_week` is not dynamic or you'll adjust.
    // If it *is* dynamic, we'll pass it from the ERB.
    picker.setAttribute("max", this.data.get("maxDate")); // Assuming you'll set data-timesheet-max-date="<%- Date.today.end_of_week %>" on the HTML element

    // Get current date from a data attribute
    // This needs to be passed from ERB as well.
    const currentDate = new Date(this.data.get("currentDate"));

    // Add event listener
    picker.addEventListener('change', (event) => {
      this.checkNewDate(event, currentDate);
    });
  }

  checkNewDate(event, currentDate) {
    const newDate = new Date(event.target.value);
    const dateDifference = parseInt((currentDate - newDate) / (1000 * 60 * 60 * 24));

    if((dateDifference > 0) || (dateDifference < -6)) {
      // You should use Turbo Drive's navigation for SPA-like behavior
      // Instead of window.location, use Turbo.visit
      // This will prevent full page reloads if the timesheet show page itself is a Turbo frame.
      // If it's a full page reload, window.location is fine.
      // For now, sticking to window.location as per your original code.
      window.location = `/timesheets/show?period=${event.target.value}`;
    }
  }

  disconnect() {
    // Clean up event listeners if necessary to prevent memory leaks (good practice)
    this.periodPickerTarget.removeEventListener('change', this.checkNewDate);
  }
}
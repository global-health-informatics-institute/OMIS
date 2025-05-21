import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    messages: Array,
    duration: Number,
    colors: Array
    color: String
  }

  connect() {
    this.index = 0
    this.showMessage()
  }

  showMessage() {
    if (this.index >= this.messagesValue.length) {
      this.element.style.display = "none"
      return
    }

    const { title, description } = this.messagesValue[this.index]
    this.element.innerHTML = `
      <div class="snackbar__title">${title}</div>
      <div class="snackbar__description">${description}</div>
    `
    this.applyStyle()

    this.index++
    setTimeout(() => this.showMessage(), this.durationValue || 3000)
  }

  applyStyle() {
    const type = this.colorsValue[this.index] || "info"
    const type = this.colorValue || "info"
    this.element.className = "snackbar snackbar--" + type
  }
}

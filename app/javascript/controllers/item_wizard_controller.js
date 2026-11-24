import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "previous", "next"]

  connect() {
    this.currentIndex = 0
    this.refresh()
  }

  previous() {
    this.currentIndex = Math.max(this.currentIndex - 1, 0)
    this.refresh()
  }

  next() {
    this.currentIndex = Math.min(this.currentIndex + 1, this.itemTargets.length - 1)
    this.refresh()
  }

  refresh() {
    const itemCount = this.itemTargets.length

    this.itemTargets.forEach((item, index) => {
      item.classList.toggle("d-none", index !== this.currentIndex)
    })

    this.previousTargets.forEach((button) => {
      button.disabled = this.currentIndex === 0
    })
    this.nextTargets.forEach((button) => {
      button.disabled = this.currentIndex >= itemCount - 1
    })
  }
}

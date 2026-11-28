import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "previous", "next"]

  connect() {
    this.currentIndex = 0
    this.refresh()
  }

  previous() {
    this.currentIndex = Math.max(this.currentIndex - 1, 0)
    this.refresh()
  }

  next() {
    this.currentIndex = Math.min(this.currentIndex + 1, this.cardTargets.length - 1)
    this.refresh()
  }

  refresh() {
    this.cardTargets.forEach((card, index) => {
      card.classList.toggle("d-none", index !== this.currentIndex)
    })

    this.previousTargets.forEach((button) => { button.disabled = this.currentIndex === 0 })
    this.nextTargets.forEach((button) => { button.disabled = this.currentIndex >= this.cardTargets.length - 1 })
  }
}

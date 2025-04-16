import { Controller } from "@hotwired/stimulus"
import confetti from "canvas-confetti"

// Connects to data-controller="confetti"
export default class extends Controller {
  connect() {
    this.timer = setInterval(() => this.launch(), 3000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  launch() {
    const particleCount = Math.floor(Math.random() * 200) + 1
    const spread = Math.floor(Math.random() * (1000 - 70)) + 70
    const originX = Math.random()
    const originY = Math.random() * 0.5 + 0.3

    confetti({
      particleCount: particleCount,
      spread: spread,
      origin: {
        x: originX,
        y: originY
      }
    })
  }
}

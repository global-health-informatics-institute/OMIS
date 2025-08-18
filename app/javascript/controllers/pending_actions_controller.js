import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filter", "list", "count"]

  connect() {
    this.filterTarget.addEventListener("change", this.filterActions.bind(this))
  }

  filterActions() {
    const selectedCategory = this.filterTarget.value.toLowerCase()
    let visibleCount = 0

    [...this.listTarget.children].forEach(actionItem => {
      const category = actionItem.dataset.category.toLowerCase()
      if (!selectedCategory || category === selectedCategory) {
        actionItem.style.display = ""
        visibleCount++
      } else {
        actionItem.style.display = "none"
      }
    })

    this.countTarget.textContent = visibleCount
  }
}


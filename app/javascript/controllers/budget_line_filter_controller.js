import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["category", "line", "trigger", "panel", "selectedLabel", "search", "options", "emptyMessage", "error"]
  static values = { categories: Object, required: Boolean }

  connect() {
    this.allLines = Array.from(this.lineTarget.options)
      .filter((option) => option.value !== "")
      .map((option) => ({
        value: option.value,
        text: option.textContent,
        category: this.categoriesValue[option.value]
      }))
    this.updateSelectedLabel()

    const savedCategory = this.categoriesValue[this.lineTarget.value]
    this.category = savedCategory || ""
    this.updateCategoryButtons()

    this.render(this.selectedCategory)
  }

  toggle() {
    if (this.panelTarget.hidden) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.panelTarget.hidden = false
    this.triggerTarget.setAttribute("aria-expanded", "true")
    this.positionPanel()
  }

  close() {
    this.panelTarget.hidden = true
    this.triggerTarget.setAttribute("aria-expanded", "false")
  }

  positionPanel() {
    const trigger = this.triggerTarget.getBoundingClientRect()
    const panel = this.panelTarget
    const spacing = 8
    const spaceAbove = trigger.top - spacing
    const spaceBelow = window.innerHeight - trigger.bottom - spacing
    const openAbove = panel.scrollHeight > spaceBelow && spaceAbove > spaceBelow
    const availableSpace = Math.max(openAbove ? spaceAbove : spaceBelow, spacing)

    panel.style.top = openAbove ? "auto" : "calc(100% + 0.25rem)"
    panel.style.bottom = openAbove ? "calc(100% + 0.25rem)" : "auto"
    panel.style.maxHeight = `${availableSpace}px`
    panel.style.overflowY = "auto"
  }

  closeOnOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  filter(event) {
    const selectedLine = this.lineTarget.value
    const category = event.currentTarget.dataset.value
    this.category = category
    this.updateCategoryButtons()
    const selectedLineMatches = this.allLines.some((line) =>
      line.value === selectedLine && (!category || line.category === category)
    )

    if (!selectedLineMatches) {
      this.lineTarget.value = ""
      this.updateSelectedLabel()
      this.lineTarget.dispatchEvent(new Event("change", { bubbles: true }))
    }

    this.render(category)
  }

  search() {
    this.render(this.selectedCategory)
  }

  select(event) {
    this.lineTarget.value = event.currentTarget.dataset.value
    this.updateSelectedLabel()
    this.errorTarget.hidden = true
    this.errorTarget.classList.remove("d-block")
    this.triggerTarget.removeAttribute("aria-invalid")
    this.lineTarget.dispatchEvent(new Event("change", { bubbles: true }))
    this.close()
    this.triggerTarget.focus()
  }

  validate(event) {
    if (!this.requiredValue || this.lineTarget.value) return

    event.preventDefault()
    this.errorTarget.hidden = false
    this.errorTarget.classList.add("d-block")
    this.triggerTarget.setAttribute("aria-invalid", "true")
    this.open()
    this.triggerTarget.focus()
  }

  get selectedCategory() {
    return this.category || ""
  }

  updateCategoryButtons() {
    this.categoryTargets.forEach((button) => {
      const selected = button.dataset.value === this.selectedCategory
      button.classList.toggle("btn-primary", selected)
      button.classList.toggle("btn-outline-primary", !selected)
      button.setAttribute("aria-pressed", selected.toString())
    })
  }

  updateSelectedLabel() {
    const selectedLine = this.allLines.find((line) => line.value === this.lineTarget.value)
    this.selectedLabelTarget.textContent = selectedLine?.text || "Select Budget Line"
  }

  render(category) {
    const query = this.searchTarget.value.trim().toLocaleLowerCase()
    const options = this.allLines.filter((line) =>
      (!category || line.category === category) && line.text.toLocaleLowerCase().includes(query)
    )
    this.optionsTarget.replaceChildren(...options.map((line) => {
      const button = document.createElement("button")
      button.type = "button"
      button.className = `list-group-item list-group-item-action${line.value === this.lineTarget.value ? " active" : ""}`
      button.textContent = line.text
      button.dataset.value = line.value
      button.dataset.action = "click->budget-line-filter#select"
      return button
    }))
    this.emptyMessageTarget.hidden = options.length > 0
  }
}

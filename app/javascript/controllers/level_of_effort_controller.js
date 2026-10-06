import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rows", "row", "project", "effort", "addButton", "removeButton", "total"]
  static values = { projects: Array, maxRows: Number }

  connect() {
    this.refresh()
  }

  add() {
    if (this.rowTargets.length >= this.maximumRows() || this.totalEffort() >= 100) return

    this.rowsTarget.insertAdjacentHTML("beforeend", this.rowMarkup())
    this.refresh()
  }

  remove(event) {
    if (this.rowTargets.length <= 1) return

    event.currentTarget.closest("[data-level-of-effort-target='row']").remove()
    this.refresh()
  }

  refresh() {
    this.refreshProjectOptions()
    const atMaximumRows = this.rowTargets.length >= this.maximumRows()
    const singleRow = this.rowTargets.length === 1
    const totalIsComplete = this.totalEffort() >= 100

    this.addButtonTargets.forEach((button) => { button.disabled = atMaximumRows || totalIsComplete })
    this.removeButtonTargets.forEach((button) => { button.disabled = singleRow })
    this.setEffortMaximums()
    this.updateTotal()
  }

  refreshProjectOptions() {
    const selectedProjects = this.projectTargets.map((select) => select.value)

    this.projectTargets.forEach((select, index) => {
      const selectedProject = select.value
      const unavailableProjects = selectedProjects.filter((project, projectIndex) => project && projectIndex !== index)

      select.replaceChildren(this.option("", "Select project"))
      this.projectsValue
        .filter((project) => project === selectedProject || !unavailableProjects.includes(project))
        .forEach((project) => select.append(this.option(project, project, project === selectedProject)))
    })
  }

  option(value, text, selected = false) {
    return new Option(text, value, selected, selected)
  }

  limitEffort(event) {
    const input = event.target
    const maximum = this.maximumEffortFor(input)

    if (Number(input.value) > maximum) input.value = maximum

    this.refresh()
  }

  setEffortMaximums() {
    this.effortTargets.forEach((input) => { input.max = this.maximumEffortFor(input) })
  }

  maximumEffortFor(input) {
    const otherEffort = this.effortTargets
      .filter((effortInput) => effortInput !== input)
      .reduce((sum, effortInput) => sum + (Number(effortInput.value) || 0), 0)

    return Math.max(0, 100 - otherEffort)
  }

  maximumRows() {
    return Math.min(this.maxRowsValue, this.projectsValue.length)
  }

  totalEffort() {
    return this.effortTargets.reduce((sum, input) => sum + (Number(input.value) || 0), 0)
  }

  updateTotal() {
    const total = this.totalEffort()
    const validTotal = total === 100

    this.element.dataset.canUpdate = validTotal ? "true" : "false"
    this.totalTarget.textContent = `Total LOE: ${total}%`
    this.totalTarget.classList.toggle("bg-success", validTotal)
    this.totalTarget.classList.toggle("bg-warning", !validTotal)
    this.totalTarget.classList.toggle("text-dark", !validTotal)
    this.notifyUpdateForm()
  }

  notifyUpdateForm() {
    this.element.dispatchEvent(new Event("input", { bubbles: true }))
  }

  rowMarkup() {
    return `
      <div class="row mt-3" data-level-of-effort-target="row">
        <div class="col-4">
          <label class="form-label">Project</label>
          <select name="projects[][project]" class="form-select" required data-level-of-effort-target="project" data-action="change->level-of-effort#refresh"></select>
        </div>
        <div class="col-4">
          <label class="form-label">Allocated Effort</label>
          <input type="number" name="projects[][allocated_effort]" step="25" max="100" min="0" class="form-control" required data-level-of-effort-target="effort" data-action="input->level-of-effort#limitEffort change->level-of-effort#limitEffort">
        </div>
        <div class="col-4 d-flex align-items-end gap-2">
          <button type="button" class="btn btn-danger" aria-label="Remove level of effort" data-level-of-effort-target="removeButton" data-action="level-of-effort#remove">−</button>
          <button type="button" class="btn btn-success" aria-label="Add level of effort" data-level-of-effort-target="addButton" data-action="level-of-effort#add">+</button>
        </div>
      </div>
    `
  }
}

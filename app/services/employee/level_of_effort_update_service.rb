# frozen_string_literal: true

class Employee::LevelOfEffortUpdateService
  def self.call(employee, projects)
    projects = projects.reject { |project| project[:project].blank? && project[:allocated_effort].blank? }
    validate_projects!(projects)

    ActiveRecord::Base.transaction do
      employee.current_projects.update_all(voided: true, end_date: Date.current)

      projects.each do |project|
        ProjectTeam.create!(
          employee: employee,
          project: Project.find_by!(short_name: project.fetch(:project)),
          allocated_effort: project.fetch(:allocated_effort),
          start_date: Date.current
        )
      end
    end
  end

  def self.validate_projects!(projects)
    raise ArgumentError, 'Add at least one project.' if projects.empty?
    raise ArgumentError, 'Each row must include a project.' if projects.any? { |project| project[:project].blank? }

    if projects.any? { |project| project[:allocated_effort].blank? }
      raise ArgumentError, 'Each project must have an allocated effort.'
    end

    selected_projects = projects.map { |project| project[:project] }
    raise ArgumentError, 'A project can only be selected once.' if selected_projects.uniq.length != selected_projects.length

    total_effort = projects.sum { |project| project[:allocated_effort].to_f }
    raise ArgumentError, 'Total allocated effort must equal 100%.' unless total_effort == 100
  end
  private_class_method :validate_projects!
end

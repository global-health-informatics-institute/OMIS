# frozen_string_literal: true

performer = Employee.find_by!(employee_id: 73, still_employed: true)
project = Project.where(is_active: true).order(:project_id).first!
assignees = Employee.where(still_employed: true).order(:employee_id)

ProjectTask.transaction do
  task = ProjectTask.find_or_initialize_by(
    project_id: project.project_id,
    performed_by: performer.employee_id,
    task_description: 'Demo: review assigned project task'
  )
  task.assign_attributes(
    estimated_duration: 1,
    deadline: 30.days.from_now,
    task_status: :open,
    reference: '/projects'
  )
  task.save!

  assignees.find_each do |employee|
    assignment = ProjectTaskAssignment.unscoped.find_or_initialize_by(
      project_task_id: task.project_task_id,
      assigned_to: employee.employee_id
    )
    assignment.update!(revoked: false)
  end

  puts "Seeded project task #{task.project_task_id} in #{project.short_name}"
  puts "Performer: employee #{performer.employee_id}"
  puts "Assigned to #{assignees.count} active employees"
end

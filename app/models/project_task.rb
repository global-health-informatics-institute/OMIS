# frozen_string_literal: true

class ProjectTask < ApplicationRecord # rubocop:disable Style/Documentation
  self.primary_key = 'project_task_id'
  default_scope { where(voided: false) }

  has_many :project_task_assignments, foreign_key: :project_task_id, dependent: :destroy
  enum :task_status, { open: 'Open', closed: 'Closed' }, suffix: true

  after_initialize :set_default_status, if: :new_record?

  TASK_STATUS_DETAILS = {
    'open' => { name: 'Open', description: 'Task is open and visible to all team members' },
    'closed' => { name: 'Closed', description: 'Task is closed and no longer visible to team members' }
  }.freeze

  def is_open # rubocop:disable Naming/PredicateName,Lint/RedundantCopDisableDirective,Naming/PredicatePrefix
    task_status == 'open'
  end

  def status_description
    TASK_STATUS_DETAILS.fetch(task_status) { {} }[:description]
  end

  def reference_url?
    return false if reference.blank?

    cleaned_reference = reference.to_s.strip
    return true if cleaned_reference.start_with?('/') && !cleaned_reference.start_with?('//')

    uri = URI.parse(cleaned_reference)
    uri.is_a?(URI::HTTP) && uri.host.present?
  rescue URI::InvalidURIError
    false
  end

  def self.direct_project_tasks(current_user)
    where('deadline >= ?', Date.current.beginning_of_day)
      .where(task_status: :open)
      .joins(:project_task_assignments)
      .where(project_task_assignments: { assigned_to: current_user.employee_id })
      .distinct
  end

  def self.delegated_project_tasks(current_user)
    where('deadline >= ?', Date.current.beginning_of_day)
      .where(performed_by: current_user.employee_id, task_status: :open)
      .joins(:project_task_assignments)
      .where.not(project_task_assignments: { assigned_to: current_user.employee_id })
      .distinct
  end

  def self.direct_project_tasks_as_json(current_user)
    tasks_as_json(direct_project_tasks(current_user))
  end

  def self.delegated_project_tasks_as_json(current_user)
    tasks_as_json(delegated_project_tasks(current_user))
  end

  def self.tasks_as_json(tasks)
    tasks_json = tasks.includes(project_task_assignments: { employee: :person }).as_json(
      methods: :reference_url?,
      include: {
        project_task_assignments: {
          methods: :employee_name
        }
      }
    )

    tasks_json.each do |task|
      task['project_task_assignments']&.reject! { |assignment| assignment['employee_name'].blank? }
    end

    tasks_json
  end
  private_class_method :tasks_as_json

  private

  def set_default_status
    self.task_status ||= :open
  end
end

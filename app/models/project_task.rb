# frozen_string_literal: true

class ProjectTask < ApplicationRecord # rubocop:disable Style/Documentation
  self.primary_key = 'project_task_id'
  default_scope { where(voided: false) }

  has_many :project_task_assignments, foreign_key: :project_task_id, dependent: :destroy
  enum :task_status, { open: 'Open', closed: 'Closed' }, suffix: true

  after_initialize :set_default_status, if: :new_record?

  # Store descriptions separately in a constant
  TASK_STATUS_DETAILS = {
    'open' => { name: 'Open', description: 'Task is open and visible to all team members' },
    'closed' => { name: 'Closed', description: 'Task is closed and no longer visible to team members' }
  }.freeze

  def is_open # rubocop:disable Naming/PredicateName
    task_status == 'open'
  end

  # Helper method to easily fetch the description
  def status_description
    TASK_STATUS_DETAILS[task_status][:description]
  end

  def reference_url?
    require 'uri'

    return false if reference.blank?

    cleaned = reference.to_s.strip

    return true if cleaned.start_with?('/')

    begin
      uri = URI.parse(cleaned)

      uri.is_a?(URI::HTTP) && uri.host.present?
    rescue URI::InvalidURIError
      false
    end
  end

  def self.direct_project_tasks(current_user)
    ProjectTask
      .where('deadline >= ?', Time.zone.now.beginning_of_day)
      .where(task_status: 'open')
      .joins(project_task_assignments: :employee) 
      .includes(:project_task_assignments)
      .where(project_task_assignments: { assigned_to: current_user.employee_id, revoked: false })
  end

  def self.delegated_project_tasks(current_user)
    where('deadline >= ?', Time.zone.now.beginning_of_day)
      .where(performed_by: current_user.employee_id, task_status: 'open')
      .joins(project_task_assignments: :employee)
      .includes(:project_task_assignments)
      .where(project_task_assignments: { revoked: false })
      .where.not(project_task_assignments: { assigned_to: current_user.employee_id })
      .distinct
  end

  def self.delegated_project_tasks_as_json(current_user)
    tasks_json = delegated_project_tasks(current_user).as_json(
      methods: :reference_url?,
      include: {
        project_task_assignments: {
          methods: :employee_name
        }
      }
    )

    # 2. Drop individual assignments of inactive/terminated employees
    filter_inactive_assignments!(tasks_json)
  end

  def self.direct_project_tasks_as_json(current_user)
    tasks_json = direct_project_tasks(current_user).as_json(
      methods: :reference_url?,
      include: {
        project_task_assignments: {
          methods: :employee_name
        }
      }
    )

    # 2. Drop individual assignments of inactive/terminated employees
    filter_inactive_assignments!(tasks_json)
  end

  private

  def set_default_status
    self.task_status ||= :open
  end

  # Helper to strip out assignments of employees who failed the default scope (name is nil)
  def self.filter_inactive_assignments!(tasks_json)
    tasks_json.each do |task|
      task['project_task_assignments']&.reject! { |assignment| assignment['employee_name'].nil? }
    end
    tasks_json
  end
  private_class_method :filter_inactive_assignments!
end
# frozen_string_literal: true

class ProjectTaskAssignment < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :project_task, foreign_key: :project_task_id, primary_key: :project_task_id
  belongs_to :employee, class_name: 'Employee', foreign_key: :assigned_to, primary_key: :employee_id,
                        optional: true

  default_scope { where(revoked: false) }

  def employee_name
    employee&.person&.full_name
  end
end

class LeaveRequest < ApplicationRecord
  # has_one :user, :foreign_key => :employee_id
  belongs_to :employee, :foreign_key =>  :employee_id

  def requester
    Employee.find(self.employee_id).person.full_name
  end

  def leave_reviewer
    Employee.find(self.reviewed_by).person.full_name
  end

  def leave_approver
    Employee.find(self.approved_by).person.full_name
  end

  def current_state
    return WorkflowState.find(self.workflow_state_id).state rescue ''
  end

  def leave_stand_in
    Employee.find(stand_in).person.full_name
  rescue StandardError
    ''
  end

  def leave_state
    WorkflowState.find(status).state
  rescue StandardError
    ''
  end

  def leave_balance
    employee = User.find_by(user_id: employee_id).employee
    (employee.leave_balance(leave_type:) - employee.used_leave_days(
      Date.today.beginning_of_year, created_at.to_date, leave_type:
    ))
  rescue StandardError
    '-- --'
  end
end

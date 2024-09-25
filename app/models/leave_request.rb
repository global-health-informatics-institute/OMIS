class LeaveRequest < ApplicationRecord
  # has_one :user, :foreign_key => :employee_id
    belongs_to :user, :foreign_key =>  :employee_id
  def requester
    Employee.find(self.employee_id).person.full_name
  end

  def reviewer
    Employee.find(self.reviewed_by).person.full_name
  end

  def approver
    Employee.find(self.approved_by).person.full_name
  end

  def current_state
    return WorkflowState.find(self.workflow_state_id).state rescue ''
  end
end

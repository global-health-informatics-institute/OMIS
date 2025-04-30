class Requisition < ApplicationRecord
  belongs_to :user, :foreign_key =>  :initiated_by
  # belongs_to :employee, :foreign_key =>  :reviewed_by
  # belongs_to :employee, :foreign_key =>  :approved_by
  # belongs_to :approver, class_name: 'User', :foreign_key =>  :approved_by
  belongs_to :project, foreign_key: :project_id
  has_many :requisition_items, :foreign_key => :requisition_id
  has_many :requisition_notes, :foreign_key => :requisition_id
  has_one :workflow_state, :foreign_key => :workflow_state_id

  def assign_state
    self.workflow_state_id = InitialState.find_by_workflow_process_id(WorkflowProcess.find_by_workflow('Petty Cash Request')).workflow_state_id
  end

  def current_state
    return WorkflowState.find(self.workflow_state_id).state rescue ''
    #self.workflow_state.state rescue status
  end

  def approver
    Employee.find(self.approved_by).person.full_name
  end
  def recalled?
    WorkflowState.find_by(workflow_state_id: workflow_state_id)&.state == 'Recalled'

  end

  def reviewer
    Employee.find(self.reviewed_by).person.full_name
  end
  def amount
    if self.requisition_type == "Petty Cash"
      return self.requisition_items.first.value
    end
  end
end

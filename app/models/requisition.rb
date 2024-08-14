class Requisition < ApplicationRecord
  belongs_to :user, :foreign_key =>  :initiated_by
  has_many :requisition_items, :foreign_key => :requisition_id
  has_many :requisition_notes, :foreign_key => :requisition_id
  has_one :workflow_state, :foreign_key => :workflow_state_id
  # before_create :assign_state

  def assign_state
    self.state = InitialState.find_by_workflow_process_id(WorkflowProcess.find_by_workflow('Petty Cash Request')).workflow_state_id
  end

  def current_state
    return WorkflowState.find(self.state).state rescue ''
    #self.workflow_state.state rescue status
  end

  def amount
    if self.requisition_type == "Petty Cash"
      return self.requisition_items.first.value
    end
  end
end

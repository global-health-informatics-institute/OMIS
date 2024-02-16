class WorkflowStateTransition < ApplicationRecord
  has_one :workflow_state, :foreign_key => :next_state
  has_one :workflow_state, :foreign_key => :workflow_state_id
  has_one :workflow_process, through: :workflow_state
end

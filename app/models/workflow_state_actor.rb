class WorkflowStateActor < ApplicationRecord
  #belongs_to :workflow_state_transition, :foreign_key => :workflow_state_transition_id
  #belongs_to :designation, :foreign_key => :designation_id
  default_scope { where(voided: false) }
end

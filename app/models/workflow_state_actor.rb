class WorkflowStateActor < ApplicationRecord
  belongs_to :workflow_state, foreign_key: :workflow_state_id, primary_key: :workflow_state_id
  belongs_to :employee_designation, foreign_key: :employee_designation_id, primary_key: :employee_designation_id
  #belongs_to :workflow_state_transition, :foreign_key => :workflow_state_transition_id
  #belongs_to :designation, :foreign_key => :designation_id
end

class WorkflowStateTransitioner < ApplicationRecord
  belongs_to :workflow_state_transition
  has_one :designation, foreign_key: :stakeholder
end

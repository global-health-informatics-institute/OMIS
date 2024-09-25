class WorkflowProcess < ApplicationRecord
  has_many :workflow_states, foreign_key: :workflow_process_id
  has_one :initial_state
end

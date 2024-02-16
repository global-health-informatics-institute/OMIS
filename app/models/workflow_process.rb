class WorkflowProcess < ApplicationRecord
  has_many :workflow_states, foreign_key: :workflow_process_id
end

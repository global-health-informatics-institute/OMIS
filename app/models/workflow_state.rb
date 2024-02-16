class WorkflowState < ApplicationRecord
  belongs_to :workflow_process, :foreign_key => :workflow_process_id
end

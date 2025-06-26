class WorkflowState < ApplicationRecord
  belongs_to :workflow_process, :foreign_key => :workflow_process_id
  #default_scope { where(voided: false) }
end

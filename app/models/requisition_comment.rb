class RequisitionComment < ApplicationRecord
  belongs_to :requisition
  belongs_to :workflow_state
end

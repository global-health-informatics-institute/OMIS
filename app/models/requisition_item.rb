class RequisitionItem < ApplicationRecord
  belongs_to :requisition, foreign_key: :requisition_id
end

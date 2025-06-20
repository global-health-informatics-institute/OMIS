class PurchaseRequestAttachment < ApplicationRecord
  belongs_to :requisition
  belongs_to :department, foreign_key: :department_id
  belongs_to :requisition, foreign_key: :requisition_id
  belongs_to :stakeholder, foreign_key: :stakeholder_id
end

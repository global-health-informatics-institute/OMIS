# frozen_string_literal: true

# Holds specific metadata for Requisitions of type 'purchase_request'.
class PurchaseRequestDetail < ApplicationRecord
  belongs_to :requisition
  belongs_to :department, foreign_key: 'department_id', optional: false
  belongs_to :donor, optional: true

  scope :active, -> { where(voided: false) }
end

# frozen_string_literal: true

class PurchaseRequest < Requisition # rubocop:disable Style/Documentation
  has_one :purchase_request_detail, foreign_key: :requisition_id, dependent: :delete
  has_one :requisition_budget_line, foreign_key: :requisition_id, dependent: :delete
  has_one :requisition_donor, foreign_key: :requisition_id, dependent: :delete


  accepts_nested_attributes_for :purchase_request_detail
  accepts_nested_attributes_for :requisition_budget_line
  accepts_nested_attributes_for :requisition_donor
end

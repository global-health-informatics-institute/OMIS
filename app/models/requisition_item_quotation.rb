# frozen_string_literal: true

# A supplier's quoted unit price for one requisition item.
class RequisitionItemQuotation < ApplicationRecord
  belongs_to :requisition_item, primary_key: :requisition_item_id
  belongs_to :supplier

  validates :supplier_id, uniqueness: { scope: :requisition_item_id }
  validates :unit_price, numericality: { greater_than: 0 }

  def unit_price=(value)
    super(value.is_a?(String) ? value.delete(',').strip : value)
  end
end

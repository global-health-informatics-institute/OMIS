# frozen_string_literal: true

# A charge applied to one requisition item. charge_value is a snapshot of the rate or fee at the time the
# charge was applied, so later changes to the global property do not change existing requisitions.
class RequisitionItemCharge < ApplicationRecord
  belongs_to :requisition_item, primary_key: :requisition_item_id
  belongs_to :charge

  validates :charge_id, uniqueness: { scope: :requisition_item_id }
  validates :charge_value, numericality: { greater_than_or_equal_to: 0 }

  # copy the current value of the charge when it is first applied
  before_validation :snapshot_charge_value, on: :create

  private

  def snapshot_charge_value
    self.charge_value ||= charge&.value
  end
end

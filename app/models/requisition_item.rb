class RequisitionItem < ApplicationRecord
  belongs_to :requisition, foreign_key: :requisition_id
  validates :quantity, numericality: { greater_than: 0 }
  validates :value, numericality: { greater_than: 0 }, allow_nil: true

  # validating petty cash limit
  validate :petty_cash_limit

  private

  # method for verifying if the entered amount is within the accepted range
  def petty_cash_limit
    return unless requisition&.requisition_type == 'Petty Cash'

    # call to GlobalProperty method
    max_limit = GlobalProperty.petty_cash_limit.to_f
    return if value.blank?

    errors.add(:value, "Cannot exceed ₦#{max_limit}") if value.to_f > max_limit
  end
end

class RequisitionItem < ApplicationRecord
  belongs_to :requisition, foreign_key: :requisition_id
  self.primary_key = 'requisition_item_id'

  # Validations
  validate :petty_cash_limit
  validate :purchase_request_threshold

  private

  # Petty cash limit validation
  def petty_cash_limit
    return unless requisition&.requisition_type == 'Petty Cash'
    return if value.blank?

    max_limit = GlobalProperty.petty_cash_limit.to_f
    if value.to_f > max_limit
      errors.add(:value, "Cannot exceed ₦#{max_limit}")
    end
  end

  # Purchase request threshold only for 'Under Procurement'
  def purchase_request_threshold
    return unless requisition&.requisition_type == 'Purchase Request'
    return unless requisition&.workflow_state&.state == 'Under Procurement'
    return if value.blank?

    max_limit = GlobalProperty.purchase_request_threshold.to_f
    if value.to_f > max_limit
      errors.add(:value, "Cannot exceed N#{max_limit}")
    end
  end
end

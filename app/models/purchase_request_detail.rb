# frozen_string_literal: true

# Holds specific metadata for Requisitions of type 'purchase_request'.
class PurchaseRequestDetail < ApplicationRecord
  belongs_to :requisition, foreign_key: 'requisition_id', primary_key: 'requisition_id', optional: false
  belongs_to :department, foreign_key: 'department_id', optional: true
  belongs_to :lpo_preparer, class_name: 'Employee', foreign_key: 'lpo_prepared_by', optional: true
  belongs_to :lpo_finance_approver, class_name: 'Employee', foreign_key: 'lpo_finance_approved_by', optional: true
  belongs_to :lpo_ed_approver, class_name: 'Employee', foreign_key: 'lpo_ed_approved_by', optional: true
  belongs_to :payment_request_preparer, class_name: 'Employee', foreign_key: 'payment_request_prepared_by', optional: true
  belongs_to :payment_request_finance_approver, class_name: 'Employee', foreign_key: 'payment_request_finance_approved_by', optional: true
  belongs_to :payment_request_ed_approver, class_name: 'Employee', foreign_key: 'payment_request_ed_approved_by', optional: true
  belongs_to :payment_voucher_preparer, class_name: 'Employee', foreign_key: 'payment_voucher_prepared_by', optional: true
  belongs_to :payment_voucher_finance_approver, class_name: 'Employee', foreign_key: 'payment_voucher_finance_approved_by', optional: true
  belongs_to :payment_voucher_ed_approver, class_name: 'Employee', foreign_key: 'payment_voucher_ed_approved_by', optional: true

  scope :active, -> { where(voided: false) }

  def quotation_quantity
    requisition.requisition_items.sum { |item| item.quantity.to_d }
  end

  def quotation_subtotal
    quotation_quantity * unit_price.to_d
  end

  def quotation_levy
    return 0.to_d unless attracts_levy?

    quotation_subtotal * GlobalProperty.levy_rate
  end

  def quotation_mra
    return 0.to_d unless attracts_mra?

    quotation_subtotal * GlobalProperty.mra_rate
  end

  def quotation_total
    quotation_subtotal + quotation_levy + quotation_mra
  end
end

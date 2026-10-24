# frozen_string_literal: true

class PurchaseRequestApprovePaymentVoucherService # rubocop:disable Style/Documentation
  class << self
    def approve_payment_voucher(id, approved_by:)
      transition_purchase_request(id, 'Approve Payment Voucher', approved_by)
    end

    private

    def transition_purchase_request(id, action, approved_by)
      purchase_request = PurchaseRequest.find(id)
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: action
      )

      approval_attributes = case purchase_request.current_state
                            when 'Pending Payment Voucher Review - Finance Team'
                              { payment_voucher_finance_approved_by: approved_by, payment_voucher_finance_approved_on: Time.current }
                            when 'Pending Payment Voucher Review - ED'
                              { payment_voucher_ed_approved_by: approved_by, payment_voucher_ed_approved_on: Time.current }
                            else
                              {}
                            end

      ActiveRecord::Base.transaction do
        purchase_request.purchase_request_detail.update!(approval_attributes)
        purchase_request.update!(workflow_state_id: transition.next_state)
      end
      purchase_request
    end
  end
end

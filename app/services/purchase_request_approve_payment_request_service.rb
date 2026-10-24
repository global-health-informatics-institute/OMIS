# frozen_string_literal: true

class PurchaseRequestApprovePaymentRequestService # rubocop:disable Style/Documentation
  class << self
    def approve_payment_request(id, approved_by:)
      transition_purchase_request(id, 'Approve Payment Request', approved_by)
    end

    private

    def transition_purchase_request(id, action, approved_by)
      purchase_request = PurchaseRequest.find(id)
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: action
      )

      approval_attributes = case purchase_request.current_state
                            when 'Pending Payment Request Review - Finance Team'
                              { payment_request_finance_approved_by: approved_by, payment_request_finance_approved_on: Time.current }
                            when 'Pending Payment Request Review - ED'
                              { payment_request_ed_approved_by: approved_by, payment_request_ed_approved_on: Time.current }
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

# frozen_string_literal: true

class PurchaseRequestPreparePaymentRequestService # rubocop:disable Style/Documentation
  class << self
    def prepare_payment_request(id, prepared_by:)
      transition_purchase_request(id, 'Prepare Payment Request', prepared_by)
    end

    private

    def transition_purchase_request(id, action, prepared_by)
      purchase_request = PurchaseRequest.find(id)
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: action
      )

      ActiveRecord::Base.transaction do
        purchase_request.purchase_request_detail.update!(payment_request_prepared_by: prepared_by, payment_request_prepared_on: Time.current)
        purchase_request.update!(workflow_state_id: transition.next_state)
      end
      purchase_request
    end
  end
end

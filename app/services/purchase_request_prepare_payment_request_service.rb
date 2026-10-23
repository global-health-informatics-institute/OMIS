# frozen_string_literal: true

class PurchaseRequestPreparePaymentRequestService # rubocop:disable Style/Documentation
  class << self
    def prepare_payment_request(id)
      transition_purchase_request(id, 'Prepare Payment Request')
    end

    private

    def transition_purchase_request(id, action)
      purchase_request = PurchaseRequest.find(id)
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: action
      )

      purchase_request.update!(workflow_state_id: transition.next_state)
      purchase_request
    end
  end
end

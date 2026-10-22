# frozen_string_literal: true

class PurchaseRequestMarkDeliveryAsFailedService # rubocop:disable Style/Documentation
  class << self
    def mark_delivery_as_failed(id)
      transition_purchase_request(id, 'Mark Delivery as Failed')
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

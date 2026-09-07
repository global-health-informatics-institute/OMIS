# app/services/purchase_request_recall_service.rb
# frozen_string_literal: true

class PurchaseRequestRescindService # rubocop:disable Style/Documentation
  class << self
    def rescind(id)
      # 1. Fetch the purchase request
      purchase_request = PurchaseRequest.find(id)

      # 2. Find the transition for the recall action
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Rescind Purchase Request'
      )

      # 3. Update to the next state
      purchase_request.update!(workflow_state_id: transition.next_state)

      purchase_request
    end
  end
end

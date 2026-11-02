# app/services/purchase_request_recall_service.rb
# frozen_string_literal: true

class PurchaseRequestUpdateService # rubocop:disable Style/Documentation
  class << self
    def update(id)
      # 1. Fetch the purchase request
      purchase_request = PurchaseRequest.find(id)

      # Chore: implement dynamic logic if more than 2 possible options exist
      # 2. Find the transition for the resubmit action
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Resubmit Purchase Request'
      )

      # 3. Update to the next state
      purchase_request.update!(workflow_state_id: transition.next_state)

      purchase_request
    end
  end
end

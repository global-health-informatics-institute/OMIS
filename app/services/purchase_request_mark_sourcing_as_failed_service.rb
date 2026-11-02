# update the state to decline request as the qoutation cannot be sourced
# frozen_string_literal: true

class PurchaseRequestMarkSourcingAsFailedService # rubocop:disable Style/Documentation
  class << self
    def mark_sourcing_as_failed(id)
      # 1. Fetch the purchase request
      purchase_request = PurchaseRequest.find(id)

      # 2. Find the transition for the recall action
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Mark Sourcing as Failed'
      )

      # 3. Update to the next state
      purchase_request.update!(workflow_state_id: transition.next_state)

      purchase_request
    end
  end
end

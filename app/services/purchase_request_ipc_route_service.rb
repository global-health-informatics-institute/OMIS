# update the state to request an ipc meeting
# frozen_string_literal: true

class PurchaseRequestIpcRouteService # rubocop:disable Style/Documentation
  class << self
    def route_to_ipc(id)
      # 1. Fetch the purchase request
      purchase_request = PurchaseRequest.find(id)

      # 2. Find the transition for the recall action
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Route to IPC'
      )

      # 3. Update to the next state
      purchase_request.update!(workflow_state_id: transition.next_state)

      purchase_request
    end
  end
end

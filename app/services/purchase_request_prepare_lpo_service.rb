# frozen_string_literal: true

class PurchaseRequestPrepareLpoService # rubocop:disable Style/Documentation
  class << self
    def prepare_lpo_request(id)
      purchase_request = PurchaseRequest.find(id)
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Prepare LPO Request'
      )

      purchase_request.update!(workflow_state_id: transition.next_state)
      purchase_request
    end
  end
end

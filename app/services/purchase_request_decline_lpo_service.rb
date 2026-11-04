# frozen_string_literal: true

class PurchaseRequestDeclineLpoService # rubocop:disable Style/Documentation
  class << self
    def decline_lpo_request(id)
      transition_purchase_request(id, 'Decline LPO Request')
    end

    private

    def transition_purchase_request(id, action)
      purchase_request = PurchaseRequest.find(id)
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: action
      )

      ActiveRecord::Base.transaction do
        purchase_request.update!(workflow_state_id: transition.next_state)
      end

      purchase_request
    end
  end
end

# frozen_string_literal: true

class PurchaseRequestRecallService # rubocop:disable Style/Documentation
  class << self
    def recall(id) # rubocop:disable Metrics/MethodLength
      purchase_request = PurchaseRequest.find(id)

      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Recall Purchase Request'
      )

      ActiveRecord::Base.transaction do
        purchase_request.update!(
          workflow_state_id: transition.next_state,
          reviewed_by: purchase_request.initiated_by,
          approved_by: nil
        )

        purchase_request.purchase_request_detail.update!(
          approved_on: nil
        )
      end

      purchase_request
    end
  end
end
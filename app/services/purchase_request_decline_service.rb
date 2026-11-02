# frozen_string_literal: true

class PurchaseRequestDeclineService # rubocop:disable Style/Documentation
  class << self
    def decline(requisition_id:, reviewed_by:) # rubocop:disable Metrics/MethodLength
      purchase_request = PurchaseRequest.find(requisition_id)

      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Decline Purchase Request'
      )

      ActiveRecord::Base.transaction do
        purchase_request.update!(
          workflow_state_id: transition.next_state,
          reviewed_by:,
          approved_by: nil
        )

        purchase_request.purchase_request_detail.update!(
          reviewed_on: Time.current,
          approved_on: nil
        )
      end

      purchase_request
    end
  end
end
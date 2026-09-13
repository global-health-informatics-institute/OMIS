# logic to change transition to sourcing qoutation
# frozen_string_literal: true

class PurchaseRequestApproveService # rubocop:disable Style/Documentation
  class << self
    def approve(requisition_id:, approved_by:) # rubocop:disable Metrics/MethodLength
      # 1. Fetch the purchase request
      purchase_request = PurchaseRequest.find(requisition_id)

      # 2. Find the transition for the recall action
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Approve Purchase Request'
      )

      # 3. Update to the next state
      purchase_request.update!(
        workflow_state_id: transition.next_state,
        approved_by:,
        reviewed_by: approved_by,
        approved_on: Date.current,
        reviewed_on: Date.current
      )

      purchase_request
      # TODO: implement mailer notier for approved
    end
  end
end

# app/services/purchase_request_approve_service.rb
# frozen_string_literal: true

class PurchaseRequestApproveService # rubocop:disable Style/Documentation
  class << self
    def approve(requisition_id:, approved_by:) # rubocop:disable Metrics/MethodLength
      purchase_request = PurchaseRequest.find(requisition_id)

      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Approve Purchase Request'
      )

      ActiveRecord::Base.transaction do
        # 1. Update core requisition state and assigned user IDs
        purchase_request.update!(
          workflow_state_id: transition.next_state,
          approved_by: approved_by
        )

        purchase_request.purchase_request_detail.update!(
          approved_on: Time.current,
          reviewed_on: Time.current
        )
      end

      # TODO: implement mailer notifier for approved
      purchase_request
    end
  end
end
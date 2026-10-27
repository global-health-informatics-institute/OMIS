# frozen_string_literal: true

class PurchaseRequestApproveLpoService # rubocop:disable Style/Documentation
  class << self
    def approve_lpo_request(id, approved_by:)
      transition_purchase_request(id, 'Approve LPO Request', approved_by)
    end

    private

    def transition_purchase_request(id, action, approved_by) # rubocop:disable Metrics/MethodLength
      purchase_request = PurchaseRequest.find(id)
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: action
      )

      approval_attributes = case purchase_request.current_state
                            when 'Pending LPO Review - Finance Team'
                              { lpo_finance_approved_by: approved_by, lpo_finance_approved_on: Time.current }
                            when 'Pending LPO Review - ED'
                              { lpo_ed_approved_by: approved_by, lpo_ed_approved_on: Time.current }
                            else
                              {}
                            end

      ActiveRecord::Base.transaction do
        purchase_request.purchase_request_detail.update!(approval_attributes)
        purchase_request.update!(workflow_state_id: transition.next_state)
      end
      PurchaseRequestSendLpoDocumentsService.call(purchase_request) if approval_attributes.key?(:lpo_ed_approved_by)

      purchase_request
    end
  end
end

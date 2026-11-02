# frozen_string_literal: true

class PurchaseRequestPrepareLpoService # rubocop:disable Style/Documentation
  class << self
    def prepare_lpo_request(id, prepared_by:)
      purchase_request = PurchaseRequest.find(id)
      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Prepare LPO Request'
      )

      ActiveRecord::Base.transaction do
        purchase_request.purchase_request_detail.update!(lpo_prepared_by: prepared_by, lpo_prepared_on: Time.current)
        purchase_request.update!(workflow_state_id: transition.next_state)
      end
      purchase_request
    end
  end
end

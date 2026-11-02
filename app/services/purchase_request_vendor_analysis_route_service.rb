# frozen_string_literal: true

class PurchaseRequestVendorAnalysisRouteService # rubocop:disable Style/Documentation
  class << self
    def forward(id)
      purchase_request = PurchaseRequest.find(id)

      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Forward to Vendor Analysis'
      )

      purchase_request.update!(workflow_state_id: transition.next_state)
      purchase_request
    end
  end
end

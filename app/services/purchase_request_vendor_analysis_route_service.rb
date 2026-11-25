# frozen_string_literal: true

class PurchaseRequestVendorAnalysisRouteService # rubocop:disable Style/Documentation
  class << self
    def forward(id)
      route(id, action: 'Require Single Quotation')
    end

    def route_to_multiple_quotations(id)
      route(id, action: 'Require Multiple Quotations')
    end

    private

    def route(id, action:)
      purchase_request = PurchaseRequest.find(id)

      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action:
      )

      purchase_request.update!(workflow_state_id: transition.next_state)
      purchase_request
    end
  end
end

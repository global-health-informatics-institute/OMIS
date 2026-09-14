# app/services/purchase_request_resubmit_service.rb
# frozen_string_literal: true

class PurchaseRequestSaveQoutationService # rubocop:disable Style/Documentation
  class << self
    def call(id:, params:)
      purchase_request = PurchaseRequest.find(id)

      ActiveRecord::Base.transaction do
        purchase_request.update!(params) if params.present?

        transition = WorkflowStateTransition.find_by!(
          workflow_state_id: purchase_request.workflow_state_id,
          action: 'Save Qoutation'
        )

        purchase_request.update!(workflow_state_id: transition.next_state)
      end

      purchase_request
    end
  end
end

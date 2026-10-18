# app/services/purchase_request_resubmit_service.rb
# frozen_string_literal: true

class PurchaseRequestSaveQoutationService # rubocop:disable Style/Documentation
  class << self
    def call(id:, params:) # rubocop:disable Metrics/MethodLength
      purchase_request = PurchaseRequest.find(id)

      ActiveRecord::Base.transaction do
        purchase_request.assign_attributes(params) if params.present?
        validate_quotation!(purchase_request)
        purchase_request.save!

        transition = WorkflowStateTransition.find_by!(
          workflow_state_id: purchase_request.workflow_state_id,
          action: 'Save Qoutation'
        )

        purchase_request.update!(workflow_state_id: transition.next_state)
      end

      purchase_request
    end

    private

    def validate_quotation!(purchase_request) # rubocop:disable Metrics/AbcSize
      purchase_request.errors.add(:vendor_name, "can't be blank") if purchase_request.vendor_name.blank?

      purchase_request.requisition_items.each do |item|
        next if item.value.present? && item.value.positive?

        item.errors.add(:value, 'must be greater than 0')
        purchase_request.errors.add(:base, 'Each item must have a positive total cost')
      end

      raise ActiveRecord::RecordInvalid, purchase_request if purchase_request.errors.any?
    end
  end
end

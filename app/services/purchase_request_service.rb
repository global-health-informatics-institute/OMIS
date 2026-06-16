# app/services/purchase_request_service.rb
# frozen_string_literal: true

class PurchaseRequestService # rubocop:disable Style/Documentation
  def self.create(payload) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    # 1. Guard against the controller passing a Requisition object
    if payload.is_a?(ActiveRecord::Base)
      raise ArgumentError, "PurchaseRequestService expects a params Hash, but received a #{payload.class.name}. Please pass `params` from the controller."
    end

    ActiveRecord::Base.transaction do
      data = prepare_create_params(payload)
      puts "PROCESSED DATA #{data}"
      requisition = Requisition.create!(data[:requisition])

      RequisitionItem.create!(
        requisition_id: requisition.id,
        item_description: data[:item][:item_description],
        quantity: data[:item][:quantity]
      )

      RequisitionDonor.create!(
        requisition_id: requisition.id,
        donor_id: data[:donor][:donor_id]
      )

      RequisitionBudgetLine.create!(
        requisition_id: requisition.id,
        budget_line_id: data[:budget_line][:budget_line_id]
      )

      requisition
    end
  end

  class << self
    private

    def prepare_create_params(payload) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      # 2. Safely convert to indifferent access
      indifferent_payload = payload.try(:with_indifferent_access) || payload

      # 3. Handle whether the controller passed `params` or `permit_purchase_request_params`
      req_params = indifferent_payload.key?(:requisition) ? indifferent_payload[:requisition] : indifferent_payload

      initiator_string = req_params[:initiated_by].to_s.strip
      name_parts = initiator_string.split

      first_name = name_parts.first
      last_name = name_parts.length > 1 ? name_parts.last : ''

      items_attrs = req_params[:requisition_items_attributes] || {}
      first_item = items_attrs.respond_to?(:values) ? items_attrs.values.first : {}
      first_item ||= {}

      budget_attrs = req_params[:requisition_budget_line_attributes] || {}
      donor_attrs = req_params[:requisition_donor_attributes] || {}

      {
        requisition: {
          project_id: req_params[:project_id],
          purpose: req_params[:purpose],
          initiated_by: Person.find_by(first_name:, last_name:)&.employee&.employee_id,
          initiated_on: req_params[:initiated_on],
          requisition_type: 'Purchase Request',
          # CORRECTED: Grab the workflow_state_id, not the primary key (.id)
          workflow_state_id: InitialState.find_by(
            workflow_process_id: WorkflowProcess.find_by(workflow: 'Purchase Request')&.workflow_process_id
          )&.workflow_state_id
        },
        item: {
          quantity: first_item[:quantity] || first_item['quantity'],
          item_description: first_item[:item_description] || first_item['item_description']
        },
        budget_line: {
          budget_line_id: budget_attrs[:budget_line_id] || budget_attrs['budget_line_id']
        },
        donor: {
          donor_id: donor_attrs[:donor_id] || donor_attrs['donor_id']
        }
      }
    end
  end
end

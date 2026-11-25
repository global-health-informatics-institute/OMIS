# frozen_string_literal: true

class PurchaseRequestSaveVendorDetailsService # rubocop:disable Style/Documentation
  class << self
    def call(id:, suppliers_params:)
      purchase_request = PurchaseRequest.find(id)
      suppliers = build_suppliers(purchase_request, suppliers_params)

      validate!(purchase_request, suppliers)

      ActiveRecord::Base.transaction do
        suppliers.each(&:save!)
        purchase_request.shortlisted_suppliers.where.not(id: suppliers.map(&:id)).destroy_all

        transition = WorkflowStateTransition.find_by!(
          workflow_state_id: purchase_request.workflow_state_id,
          action: 'Save Vendor Details'
        )
        purchase_request.update!(workflow_state_id: transition.next_state)
      end

      purchase_request
    end

    private

    def build_suppliers(purchase_request, suppliers_params)
      suppliers_params.values.filter_map do |attributes|
        next if attributes.values.all?(&:blank?)

        email = attributes[:email].to_s.strip.downcase
        supplier = Supplier.unscoped.find_or_initialize_by(requisition_id: purchase_request.requisition_id, email:)
        supplier.assign_attributes(
          name: attributes[:name].to_s.strip,
          mobile_number: attributes[:mobile_number].to_s.strip,
          email:
        )
        supplier
      end
    end

    def validate!(purchase_request, suppliers)
      minimum = minimum_supplier_count(purchase_request)
      if suppliers.size < minimum
        purchase_request.errors.add(:base, "At least #{minimum} suppliers must be saved before price entry")
      end

      suppliers.each do |supplier|
        next if supplier.valid?

        supplier.errors.full_messages.each { |message| purchase_request.errors.add(:base, "Supplier #{message}") }
      end

      raise ActiveRecord::RecordInvalid, purchase_request if purchase_request.errors.any?
    end

    def minimum_supplier_count(purchase_request)
      return PurchaseRequest.multiple_quotations_required if
        purchase_request.current_state == 'Pending Vendor Shortlisting - Multiple Quotation'

      1
    end
  end
end

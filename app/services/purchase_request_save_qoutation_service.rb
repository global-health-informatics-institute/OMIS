# app/services/purchase_request_resubmit_service.rb
# frozen_string_literal: true

class PurchaseRequestSaveQoutationService # rubocop:disable Style/Documentation
  class << self
    def call(id:, params:, item_unit_prices:, item_charge_ids:) # rubocop:disable Metrics/MethodLength
      purchase_request = PurchaseRequest.find(id)

      ActiveRecord::Base.transaction do
        purchase_request.assign_attributes(params) if params.present?
        item_quotations = validate_and_calculate_quotation!(
          purchase_request,
          item_unit_prices:,
          item_charge_ids:
        )
        purchase_request.save!
        item_quotations.map { |quotation| quotation[:supplier] }.uniq.each(&:save!)
        save_item_quotations!(item_quotations, update_item_values: !supplier_price_entry?(purchase_request))

        transition = WorkflowStateTransition.find_by!(
          workflow_state_id: purchase_request.workflow_state_id,
          action: 'Save Qoutation'
        )

        purchase_request.update!(workflow_state_id: transition.next_state)
      end

      purchase_request
    end

    private

    def validate_and_calculate_quotation!(purchase_request, item_unit_prices:, item_charge_ids:)
      suppliers = quotation_suppliers(purchase_request)
      purchase_request.errors.add(:base, 'At least one shortlisted supplier is required before price entry') if suppliers.empty?
      suppliers.each { |supplier| validate_supplier(supplier, purchase_request) }

      shared_charge_ids = shared_charge_ids(purchase_request, item_charge_ids, suppliers)
      item_quotations = suppliers.flat_map do |supplier|
        build_item_quotations(
          purchase_request,
          supplier:,
          item_unit_prices: prices_for_supplier(purchase_request, supplier, item_unit_prices),
          item_charge_ids: shared_charge_ids
        )
      end

      total = item_quotations.sum { |quotation| quotation[:total] }
      validate_total_for_routing(purchase_request, total) if purchase_request.errors.empty?

      raise ActiveRecord::RecordInvalid, purchase_request if purchase_request.errors.any?

      item_quotations
    end

    def quotation_suppliers(purchase_request)
      return purchase_request.shortlisted_suppliers.to_a if supplier_price_entry?(purchase_request)

      [build_supplier(purchase_request)]
    end

    def build_supplier(purchase_request)
      detail = purchase_request.purchase_request_detail
      supplier = Supplier.unscoped.find_or_initialize_by(
        requisition_id: purchase_request.requisition_id,
        email: detail.vendor_email.to_s.strip.downcase
      )
      supplier.assign_attributes(
        name: purchase_request.vendor_name.to_s.strip,
        mobile_number: detail.vendor_mobile_number.to_s.strip,
        email: detail.vendor_email.to_s.strip.downcase
      )
      supplier
    end

    def validate_supplier(supplier, purchase_request)
      return if supplier.valid?

      supplier.errors.full_messages.each { |message| purchase_request.errors.add(:base, "Supplier #{message}") }
    end

    def build_item_quotations(purchase_request, supplier:, item_unit_prices:, item_charge_ids:)
      purchase_request.requisition_items.map.with_index(1) do |item, number|
        unit_price = parse_unit_price(item_unit_prices[item.requisition_item_id.to_s])
        item_label = "#{supplier.name}: #{item.item_name.presence || "Item #{number}"}"

        unless unit_price.positive?
          purchase_request.errors.add(:base, "#{item_label} unit price must be greater than 0")
        end

        selected_charge_ids = Array(item_charge_ids[item.requisition_item_id.to_s]).reject(&:blank?).map(&:to_i).uniq
        charges = Charge.where(id: selected_charge_ids, applies_to_item: true).includes(:global_property).to_a

        if charges.size != selected_charge_ids.size
          purchase_request.errors.add(:base, "#{item_label} has an invalid item charge")
        end

        subtotal = item.quantity.to_d * unit_price
        total = charges.reduce(subtotal) do |running_total, charge|
          charge.rate? ? running_total + (subtotal * charge.value) : running_total + charge.value
        end

        { item:, supplier:, unit_price:, charges:, total: total.round(2) }
      end
    end

    def parse_unit_price(value)
      BigDecimal(value.to_s.delete(',').strip)
    rescue ArgumentError
      0.to_d
    end

    def prices_for_supplier(purchase_request, supplier, item_unit_prices)
      return item_unit_prices unless supplier_price_entry?(purchase_request)

      item_unit_prices.fetch(supplier.id.to_s, {})
    end

    def shared_charge_ids(purchase_request, item_charge_ids, suppliers)
      return item_charge_ids unless supplier_price_entry?(purchase_request)

      item_charge_ids.fetch(suppliers.first.id.to_s, {})
    end

    def save_item_quotations!(item_quotations, update_item_values:)
      item_quotations.each do |quotation|
        item = quotation[:item]
        item.update!(value: quotation[:total]) if update_item_values
        item.requisition_item_quotations.find_or_initialize_by(supplier: quotation[:supplier])
            .update!(unit_price: quotation[:unit_price])
      end

      save_item_charges!(item_quotations)
    end

    def save_item_charges!(item_quotations)
      item_quotations.group_by { |quotation| quotation[:item] }.each do |item, quotations|
        item.requisition_item_charges.delete_all
        quotations.first[:charges].each { |charge| item.requisition_item_charges.create!(charge:) }
      end
    end

    def validate_total_for_routing(purchase_request, total)
      threshold = PurchaseRequest.multiple_quotations_threshold

      Rails.logger.info("quotation_total=#{total.inspect} threshold=#{threshold}")

      case purchase_request.current_state.to_s.downcase
      when 'pending vendor analysis - single quotation'
        purchase_request.errors.add(:base, "Total must be less than #{threshold}") if total >= threshold
      end
    end

    def supplier_price_entry?(purchase_request)
      purchase_request.current_state.in?([
                                           'Pending Price Entry - IPC',
                                           'Pending Price Entry - Multiple Quotation'
                                         ])
    end
  end
end

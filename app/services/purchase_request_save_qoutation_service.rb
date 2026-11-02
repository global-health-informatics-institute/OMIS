# app/services/purchase_request_resubmit_service.rb
# frozen_string_literal: true

class PurchaseRequestSaveQoutationService # rubocop:disable Style/Documentation
  class << self
    def call(id:, params:) # rubocop:disable Metrics/MethodLength
      purchase_request = PurchaseRequest.find(id)

      ActiveRecord::Base.transaction do
        purchase_request.assign_attributes(params) if params.present?
        validate_and_calculate_quotation!(purchase_request)
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

    def validate_and_calculate_quotation!(purchase_request) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      purchase_request.errors.add(:vendor_name, "can't be blank") if purchase_request.vendor_name.blank?

      detail = purchase_request.purchase_request_detail
      validate_detail_pricing(detail, purchase_request)
      validate_vendor_contact(detail, purchase_request)
      assign_quotation_total!(purchase_request, detail) if purchase_request.errors.empty?

      validate_total_for_routing(purchase_request) if purchase_request.errors.empty?

      raise ActiveRecord::RecordInvalid, purchase_request if purchase_request.errors.any?
    end

    def validate_detail_pricing(detail, purchase_request)
      add_detail_error(detail, purchase_request, :unit_price, 'must be greater than 0') unless detail.unit_price&.positive?
      add_detail_error(detail, purchase_request, :attracts_levy, 'must be selected') if detail.attracts_levy.nil?
      add_detail_error(detail, purchase_request, :attracts_mra, 'must be selected') if detail.attracts_mra.nil?
    end

    def add_detail_error(detail, purchase_request, attribute, message)
      detail.errors.add(attribute, message)
      purchase_request.errors.add(:base, "#{attribute.to_s.humanize} #{message}")
    end

    def validate_vendor_contact(detail, purchase_request)
      if detail.vendor_mobile_number.blank?
        add_detail_error(detail, purchase_request, :vendor_mobile_number, "can't be blank")
      elsif !valid_phone_number?(detail.vendor_mobile_number)
        add_detail_error(detail, purchase_request, :vendor_mobile_number, 'must be a valid phone number')
      end

      return if detail.vendor_email&.match?(URI::MailTo::EMAIL_REGEXP)

      add_detail_error(detail, purchase_request, :vendor_email, 'must be a valid email address')
    end

    def valid_phone_number?(phone_number)
      digits = phone_number.scan(/\d/)

      phone_number.match?(/\A\+?\d[\d\s().-]*\z/) && digits.length.between?(7, 15)
    end

    def assign_quotation_total!(purchase_request, detail)
      purchase_request.requisition_items.each_with_index do |item, index|
        item.value = index.zero? ? detail.quotation_total.round(2) : nil
      end
    end

    def validate_total_for_routing(purchase_request)
      threshold = PurchaseRequest.ipc_threshold
      total = purchase_request.purchase_request_detail.quotation_total

      case purchase_request.current_state.to_s.downcase
      when 'pending ipc - vendor analysis'
        purchase_request.errors.add(:base, "Total must be at least #{threshold}") if total < threshold
      when 'pending vendor analysis'
        purchase_request.errors.add(:base, "Total must be less than #{threshold}") if total >= threshold
      end
    end
  end
end

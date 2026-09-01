# app/services/purchase_request_service.rb
# frozen_string_literal: true

class PurchaseRequestShowService # rubocop:disable Style/Documentation
  class << self
    def show(id)
      # 1. Guard against the controller passing a Requisition object
      if id.is_a?(ActiveRecord::Base)
        raise ArgumentError,
              "PurchaseRequestShowService expects a params Hash, but received a #{id.class.name}. Please pass `params` from the controller." # rubocop:disable Layout/LineLength
      end

      build_requisition_attributes(id)
    end

    private

    def build_requisition_attributes(requisition_id)
      # a complete purchase request requisition object with all its associated data
      Requisition.includes(
        :requisition_items,
        :requisition_budget_line,
        :requisition_donor
      ).find(requisition_id)
    end
  end
end

# frozen_string_literal: true

module Requisitions
  class PurchaseRequestsController < ApplicationController # rubocop:disable Style/Documentation
    def index
      @purchase_requests = Requisition.where(
        request_type: 'purchase request'
      ).order(created_at: :desc).limit(10)
    end

    def new
      # This variable is already initialized in parent controller (RequisitionController)
      @purchase_request = Requisition.new
    end

    def create
      @purchase_request = Requisition.new(purchase_request_params)
      puts "Purchase Request Params: #{@purchase_request.inspect}" # Debugging line
    end

    def show
      @test_requisition = Requisition.first
    end

    def update; end

    def destroy; end

    def approve; end

    def decline; end

    private

    def purchase_request_params
      params.require(:requisition).permit(
        :project_id,
        :donor_id,
        :initiated_by,
        :initiated_on,
        :purpose,
        requisition_items_attributes: %i[id item_description quantity _destroy],
        requisition_budget_lines: [:budget_line_id],
        donor: [:donor_id]
      )
    end
  end
end

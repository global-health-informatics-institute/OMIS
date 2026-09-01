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
      @purchase_request = PurchaseRequestCreateService.create(permit_purchase_request_params)
      flash[:notice] = 'Purchase request successfully submitted'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def show
      @purchase_request = PurchaseRequestShowService.show(params[:id])
    end

    def update; end

    def destroy; end

    def approve; end

    def decline; end

    private

    def permit_purchase_request_params
      params.require(:requisition).permit(
        :project_id,
        :donor_id,
        :initiated_by,
        :initiated_on,
        :purpose,
        requisition_items_attributes: %i[id item_description quantity _destroy],
        requisition_budget_line_attributes: %i[id budget_line_id _destroy],
        requisition_donor_attributes: %i[id donor_id _destroy],
      )
    end
  end
end

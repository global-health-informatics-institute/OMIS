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
    end

    def create
      @purchase_request = PurchaseRequestCreateService.create(permit_purchase_request_params)
      flash[:notice] = 'Purchase request successfully submitted'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def show
      @purchase_request = PurchaseRequestShowService.show(params[:id])
      @possible_actions = @purchase_request.available_actions(
        user: current_user,
        is_owner: @purchase_request.initiated_by == current_user.id,
        is_supervisor: current_user.employee&.current_supervisees&.pluck(:supervisee)&.include?(@purchase_request.initiated_by) # rubocop:disable Layout/LineLength
      )
    end

    # State: Pending Supervisor Approval
    def recall
      # TODO: Implement recall logic in the service layer
      @purchase_request = PurchaseRequestRecallService.recall(params[:id])
      flash[:notice] = 'Purchase request successfully recalled'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def rescind
      # TODO: Implement rescind logic in the service layer
      @purchase_request = PurchaseRequestRescindService.rescind(params[:id])
      flash[:notice] = 'Purchase request successfully rescinded'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def approve
      # TODO: Implement approve logic in the service layer
      @purchase_request = PurchaseRequestApproveService.approve(params[:id])
      flash[:notice] = 'Purchase request successfully approved'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def decline
      # TODO: Implement decline logic in the service layer
      @purchase_request = PurchaseRequestDeclineService.decline(params[:id])
      flash[:notice] = 'Purchase request successfully declined'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end
    # end of state: Pending Supervisor Approval

    def update
      @purchase_request = PurchaseRequestUpdateService.update(params[:id])
      flash[:notice] = 'Purchase request successfully updated'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def route_to_ipc
      @purchase_request = PurchaseRequestIpcRouteService.route_to_ipc(params[:id])
      flash[:notice] = 'Purchase request successfully updated'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def route_to_lpo
      @purchase_request = PurchaseRequestLpoRouteService.route_to_lpo(params[:id])
      flash[:notice] = 'Purchase request successfully updated'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def mark_sourcing_as_failed
      @purchase_request = PurchaseRequestMarkSourcingAsFailedService.mark_sourcing_as_failed(params[:id])
      flash[:notice] = 'Purchase request successfully updated'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def resubmit; end

    def destroy; end

    private

    def permit_purchase_request_params
      params.require(:purchase_request).permit(
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

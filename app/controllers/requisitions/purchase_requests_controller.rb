# frozen_string_literal: true

module Requisitions
  class PurchaseRequestsController < ApplicationController # rubocop:disable Style/Documentation,Metrics/ClassLength
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
      load_possible_actions
    end

    # State: Pending Supervisor Approval
    def recall
      @purchase_request = PurchaseRequestRecallService.recall(params[:id])
      flash[:notice] = 'Purchase request successfully recalled'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def rescind
      @purchase_request = PurchaseRequestRescindService.rescind(params[:id])
      flash[:notice] = 'Purchase request successfully rescinded'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def resubmit # rubocop:disable Metrics/MethodLength
      # Pass the permitted parameters to the service, or an empty hash if none were sent
      safe_params = params[:purchase_request].present? ? permit_purchase_request_params : {}

      @purchase_request = PurchaseRequestResubmitService.call(
        id: params[:id],
        params: safe_params
      )

      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    rescue ActiveRecord::RecordInvalid => e
      # If they tried to resubmit but left a required field blank
      @purchase_request = e.record
      load_possible_actions

      flash.now[:alert] = 'Please fix the errors before resubmitting.'
      render :edit, status: :unprocessable_entity
    end

    def approve # rubocop:disable Metrics/AbcSize
      @purchase_request = PurchaseRequestApproveService.approve(
        requisition_id: params[:id],
        approved_by: current_user&.employee&.employee_id || current_user&.id
      )

      flash[:notice] = 'Purchase request successfully approved'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      flash[:alert] = "Failed to approve request: #{e.message}"
      redirect_to requisitions_purchase_requests_path
    end

    def decline
      @purchase_request = PurchaseRequestDeclineService.decline(
        requisition_id: params[:id],
        reviewed_by: current_user&.employee&.employee_id || current_user&.id
      )
      flash[:notice] = 'Purchase request successfully declined'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end
    # end of state: Pending Supervisor Approval

    def update
      @purchase_request = PurchaseRequestUpdateService.update(params[:id])
      flash[:notice] = 'Purchase request successfully updated'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def route_to_ipc_vendor_analysis
      @purchase_request = PurchaseRequestIpcRouteService.route_to_ipc(params[:id])
      flash[:notice] = 'Purchase request successfully updated'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    end

    def forward_to_vendor_analysis
      @purchase_request = PurchaseRequestVendorAnalysisRouteService.forward(params[:id])
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

    def save_qoutation # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      safe_params = params[:purchase_request].present? ? permit_purchase_request_params : {}

      @purchase_request = PurchaseRequestSaveQoutationService.call(
        id: params[:id],
        params: safe_params
      )

      flash[:notice] = 'Quotation saved successfully'
      redirect_to controller: 'requisitions/purchase_requests', action: 'show', id: @purchase_request.requisition_id
    rescue ActiveRecord::RecordInvalid => e
      # If they tried to resubmit but left a required field blank
      @purchase_request = e.record
      @possible_actions = @purchase_request.available_actions(user: current_user)

      flash.now[:alert] = 'Enter a supplier and a positive total cost for every item.'
      render :show, status: :unprocessable_entity
    end

    def route_to_lpo_request
      @purchase_request = PurchaseRequestLpoRequestRouteService.route_to_lpo_request(params[:id])
      flash[:notice] = 'Purchase request routed for LPO submission'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def forward_to_payment_request
      @purchase_request = PurchaseRequestPaymentRequestForwardService.forward_to_payment_request(params[:id])
      flash[:notice] = 'Purchase request forwarded to payment request'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def prepare_lpo_request
      @purchase_request = PurchaseRequestPrepareLpoService.prepare_lpo_request(params[:id])
      flash[:notice] = "Purchase request's LPO has been prepared"
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def approve_lpo_request
      @purchase_request = PurchaseRequestApproveLpoService.approve_lpo_request(params[:id])
      flash[:notice] = 'LPO request approved'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def choose_other_vendor
      @purchase_request = PurchaseRequestChooseOtherVendorService.choose_other_vendor(params[:id])
      flash[:notice] = 'Purchase request returned for another vendor selection'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def confirm_delivery
      @purchase_request = PurchaseRequestConfirmDeliveryService.confirm_delivery(params[:id])
      flash[:notice] = 'Delivery confirmed and awaiting requester acceptance'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def mark_delivery_as_failed
      @purchase_request = PurchaseRequestMarkDeliveryAsFailedService.mark_delivery_as_failed(params[:id])
      flash[:notice] = 'Delivery marked as failed'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def accept_item
      @purchase_request = PurchaseRequestAcceptItemService.accept_item(params[:id])
      flash[:notice] = 'Item accepted and forwarded for payment request'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def decline_item
      @purchase_request = PurchaseRequestDeclineItemService.decline_item(params[:id])
      flash[:notice] = 'Item declined and returned for delivery confirmation'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def prepare_payment_request
      @purchase_request = PurchaseRequestPreparePaymentRequestService.prepare_payment_request(params[:id])
      flash[:notice] = 'Payment request prepared and sent for finance review'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def approve_payment_request
      @purchase_request = PurchaseRequestApprovePaymentRequestService.approve_payment_request(params[:id])
      flash[:notice] = 'Payment request approved'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def terminate_payment_request
      @purchase_request = PurchaseRequestTerminatePaymentRequestService.terminate_payment_request(params[:id])
      flash[:notice] = 'Payment request terminated'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def prepare_payment_voucher
      @purchase_request = PurchaseRequestPreparePaymentVoucherService.prepare_payment_voucher(params[:id])
      flash[:notice] = 'Payment voucher prepared and sent for finance review'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def approve_payment_voucher
      @purchase_request = PurchaseRequestApprovePaymentVoucherService.approve_payment_voucher(params[:id])
      flash[:notice] = 'Payment voucher approved'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def terminate_payment_voucher
      @purchase_request = PurchaseRequestTerminatePaymentVoucherService.terminate_payment_voucher(params[:id])
      flash[:notice] = 'Payment voucher terminated'
      redirect_to requisitions_purchase_request_path(@purchase_request)
    end

    def destroy; end

    private

    def permit_purchase_request_params # rubocop:disable Metrics/MethodLength
      params.require(:purchase_request).permit(
        :project_id,
        :donor_id,
        :initiated_by,
        :initiated_on,
        :purpose,
        :vendor_name,
        requisition_items_attributes: %i[id item_description quantity _destroy],
        requisition_budget_line_attributes: %i[id budget_line_id _destroy],
        requisition_donor_attributes: %i[id donor_id _destroy],
        purchase_request_detail_attributes: %i[
          id department_id unit_price attracts_levy attracts_mra vendor_mobile_number vendor_email
        ]
      )
    end

    def load_possible_actions
      is_requester = @purchase_request.requester?(current_user)
      is_supervisor = current_user.employee&.current_supervisees&.pluck(:supervisee)&.include?(@purchase_request.initiated_by) # rubocop:disable Layout/LineLength

      @possible_actions = @purchase_request.available_actions(
        user: current_user,
        is_owner: is_requester,
        is_supervisor: is_supervisor,
        owner_only: is_requester
      )
    end
  end
end

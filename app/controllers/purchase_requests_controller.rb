# app/controllers/purchase_requests_controller.rb
class PurchaseRequestsController < ApplicationController
  # Inherit from ApplicationController or a more specific base controller if you have one
  # before_action :authenticate_user! # Example: if you have

  def new
    # Initialize a new Requisition object for a purchase request
    @purchase_request = Requisition.new(requisition_type: "Purchase Request")
    # You might also want to load project options here if they are specific to purchase requests
    @project_options = Project.all.map { |p| [p.full_name, p.id] } # Example
    # @selected_project = Project.find_by(id: params[:"prj"]) # Example for pre-selecting
  end

  def create
    @purchase_request = Requisition.new(purchase_request_params)
    @purchase_request.requisition_type = "Purchase Request" # Ensure it's explicitly set here as well

    if @purchase_request.save
      # Redirect to a success page or the new purchase request's show page
      redirect_to purchase_request_path(@purchase_request), notice: 'Purchase Request was successfully created.'
    else
      # Re-render the form if save fails
      @project_options = Project.all.map { |p| [p.full_name, p.id] } # Reload options for re-render
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @purchase_request = Requisition.find(params[:id])
  end

  # Add other actions as needed (edit, update, index, destroy) specific to purchase requests

  private

  def purchase_request_params
    params.require(:requisition).permit(
      :request_date,
      :requested_by,
      :item_requested,
      :quantity,
      :project_id,
      :description,
      :workflow_state_id # Make sure to permit this as it's a hidden field
    )
  end
end
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
    @purchase_request.requisition_type = "Purchase Request"

    # Assign the value from :item_requested to the :purpose attribute
    # This happens before saving the record to the database
    @purchase_request.purpose = @purchase_request.item_requested if @purchase_request.item_requested.present?

    if @purchase_request.save
      # Redirect to a success page or the new purchase request's show page
      redirect_to "/requisitions/#{@requisition_id}", notice: 'Purchase Request was successfully created.'
    else
      # Re-render the form if save fails
      @project_options = Project.all.collect { |x| [x.project_name, x.id] }
      @selected_project = Project.find_by_short_name(params[:prj])# Reload options for re-render
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @purchase_request = Requisition.find(params[:id])
    @projects = Project.all
  end

  # Add other actions as needed (edit, update, index, destroy) specific to purchase requests

  private

  def purchase_request_params
    params.require(:requisition).permit(
      :initiated_on,
      :initiated_by,
      :item_requested, # Keep this permitted to capture the input from the form
      :requisition_type,
      :project_id,
      :item_description,
      :workflow_state_id, 
      :purpose,
      requisition_items_attributes: [:quantity, :item_description, :_destroy] # adjust attributes as needed
  )
    
  end
end

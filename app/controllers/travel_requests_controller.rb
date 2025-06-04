# app/controllers/travel_request_controller.rb
class TravelRequestController < ApplicationController
  # GET /travel_request/new
  # This action will render the form for a new travel request
  def new
    @requisition = Requisition.new # Still using @requisition as per your form model
    # You'll need to define @employees for your select field.
    @employees = Employee.all # Make sure Employee model exists and has data
  end

  # POST /travel_request
  # This action handles the form submission to create a new travel request
  def create
    @requisition = Requisition.new(travel_request_params)

    if @requisition.save
      flash[:notice] = "Travel Request submitted successfully!"
      # Redirect to a confirmation page or a list of requests
      redirect_to travel_request_show_path(@requisition) # You'll need a show action and route
    else
      # If there are validation errors, re-render the 'new' form with errors
      # It's important to re-initialize @employees if you re-render 'new'
      @employees = Employee.all
      render :new, status: :unprocessable_entity # Ensures the browser gets the correct status code
    end
  end

  # GET /travel_request/:id
  # You'll likely want a show action to display the details of a submitted request
  def show
    @requisition = Requisition.find(params[:id])
  end

  private
  def travel_request_params
    params.require(:requisition).permit(
      :Department,
      :Destination,
      :Project,
      :departure_date,
      :return_date, # Make sure this matches your form if it's there
      :purpose,
      :amount_requested,
      employee_ids: [], # Use `employee_ids` if `Requisition` `has_and_belongs_to_many` or `has_many :through` Employees
      # Or if `project_id` in your form is meant for employee IDs, then:
      # project_id: [],

      # For the external travellers table, as discussed, the current form structure
      # means only the last row's data will be captured unless you modify the view
      # to use array notation or nested attributes. For now, matching current view.
      :name_of_external_travellers, # This will capture the first row's value for this field.
      :organization,                # This will capture the first row's value for this field.
    )
  end
end
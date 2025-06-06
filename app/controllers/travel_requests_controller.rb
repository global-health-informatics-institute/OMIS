# app/controllers/travel_request_controller.rb
class TravelRequestsController < ApplicationController
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
      :Vehicle,
      :Destination,
      :Project,
      :departure_date,
      :return_date, # Make sure this matches your form if it's there
      :purpose,
      :amount_requested,
      employee_ids: []
    )
  end
end
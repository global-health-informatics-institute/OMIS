class TravelRequestsController < ApplicationController
  before_action :set_travel_request, only: [:show]

  def new
    @travel_request = TravelRequest.new(session[:travel_request_params])
    @travel_request.current_step = session[:travel_request_step] || TravelRequest.steps.first

    if @travel_request.current_step == 'financial_details'
      @travel_request.lunch_allowance ||= GlobalProperty.lunch_allowance.to_f
      @travel_request.dinner_allowance ||= GlobalProperty.dinner_allowance.to_f
      @travel_request.accommodation ||= GlobalProperty.accommodation.to_f
      @travel_request.unit_fuel_cost ||= GlobalProperty.unit_fuel_cost.to_f
    end
  end

  def create
    # When a new request is created, it always starts at the first step
    @travel_request = TravelRequest.new(travel_request_params)
    @travel_request.current_step = TravelRequest.steps.first # Ensure current_step is set for initial validation

    if @travel_request.current_step_valid?
      session[:travel_request_params] = travel_request_params.to_h # Convert to_h to store in session
      session[:travel_request_step] = TravelRequest.steps.second
      redirect_to new_travel_request_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:back_button]
      current_step_index = TravelRequest.steps.index(session[:travel_request_step])
      session[:travel_request_step] = TravelRequest.steps[current_step_index - 1]
      @travel_request = TravelRequest.new(session[:travel_request_params])
      @travel_request.current_step = session[:travel_request_step]
      render :new and return
    end

    @travel_request = TravelRequest.new(session[:travel_request_params])
    @travel_request.assign_attributes(travel_request_params)
    @travel_request.current_step = session[:travel_request_step]

    if @travel_request.current_step_valid?
      if @travel_request.current_step == TravelRequest.steps.last
        # At the final step, save the request
        if @travel_request.save
          grand_total = @travel_request.calculate_total_allowance + @travel_request.calculate_total_fuel_cost
          @travel_request.create_requisition_item!(grand_total: grand_total)

          session[:travel_request_params] = nil
          session[:travel_request_step] = nil
          flash[:notice] = "Travel request created successfully!"
          redirect_to @travel_request
        else
          render :new, status: :unprocessable_entity
        end
      else
        # Not the last step, update session params and advance step
        # Merge new params with existing session params
        session[:travel_request_params] = session[:travel_request_params].to_h.merge(travel_request_params.to_h)
        session[:travel_request_step] = TravelRequest.steps[TravelRequest.steps.index(@travel_request.current_step) + 1]
        redirect_to new_travel_request_path
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # loaded by set_travel_request
  end

  private

  def set_travel_request
    @travel_request = TravelRequest.find(params[:id])
  end

  def travel_request_params
    params.require(:travel_request).permit(
      :current_step, 
      :destination, 
      :distance,
      :traveler_names,
      :departure_date, 
      :departure_time,
      :return_date,
      :return_time
      # :purpose,
      # :department,
      # :project,
      # :unit_fuel_cost,
      # :consumption,
      # :lunch_allowance,
      # :dinner_allowance,
      # :accommodation
    )
  end
end
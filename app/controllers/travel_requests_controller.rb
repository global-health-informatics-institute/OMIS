class TravelRequestsController < ApplicationController
  before_action :set_travel_request, only: [:show]

  def new
    @travel_request = TravelRequest.new(session[:travel_request_params])
    @travel_request.current_step = session[:travel_request_step] || TravelRequest.steps.first
    prepare_project_options


    # Set default values for financial details if it's the current step
    if @travel_request.current_step == 'financial_details'
      # Ensure GlobalProperty.lunch_allowance etc. return numeric values (e.g., .to_f)
      @travel_request.lunch_allowance ||= GlobalProperty.lunch_allowance.to_f
      @travel_request.dinner_allowance ||= GlobalProperty.dinner_allowance.to_f
      @travel_request.accommodation ||= GlobalProperty.accommodation.to_f
      @travel_request.unit_fuel_cost ||= GlobalProperty.unit_fuel_cost.to_f
    end
  end

  # This action handles the submission of the FIRST step of the multi-step form.
  # It does NOT save the Requisition or TravelRequest to the database yet.
  def create
    @travel_request = TravelRequest.new(travel_request_params)
    @travel_request.current_step = TravelRequest.steps.first # Always start with the first step's validation
    prepare_project_options

    if @travel_request.current_step_valid?
      # Store all permitted parameters (including attr_accessor ones) in the session
      session[:travel_request_params] = travel_request_params.to_h
      # Advance the step in the session to prepare for the next form rendering
      session[:travel_request_step] = TravelRequest.steps.second
      session[:vehicle_consumption] = params[:vehicle_consumption]
      @travel_request.distance ||= session[:travel_request_params]["distance"]
      session[:travel_request_params] ||= {}
      session[:travel_request_params]["selected_traveler_count"] = params[:selected_traveler_count]

      redirect_to new_travel_request_path
    else
      # If validation fails for the first step, re-render the 'new' template with errors
      render :new, status: :unprocessable_entity
    end
  end

  # This action handles submissions for ALL subsequent steps (2, 3, ..., final).
  # The final saving to the database happens only when @travel_request.current_step is the last step.
  def update
    # Handle 'Back' button functionality
    if params[:back_button]
      current_step_index = TravelRequest.steps.index(session[:travel_request_step])
      session[:travel_request_step] = TravelRequest.steps[current_step_index - 1] # Go back one step
      @travel_request = TravelRequest.new(session[:travel_request_params]) # Rebuild from session
      @travel_request.current_step = session[:travel_request_step] # Set current step for display
      render :new and return # Render the previous step's form
    end

    # Rebuild @travel_request from session (contains previous steps' data)
    @travel_request = TravelRequest.new(session[:travel_request_params])
    # Assign attributes from the current form submission (merges with session data)
    @travel_request.assign_attributes(travel_request_params)
    # Set the current step from the session for validation
    @travel_request.current_step = session[:travel_request_step]

    # Validate data for the current step
    if @travel_request.current_step_valid?
      if @travel_request.current_step == TravelRequest.steps.last
        ActiveRecord::Base.transaction do
          # 1. Determine the workflow state for Travel Requests
          travel_workflow_process = WorkflowProcess.find_by_workflow('Travel Request')
          unless travel_workflow_process
            # Raise an error if the workflow process is not defined
            raise "WorkflowProcess 'Travel Request' not found. Please define it."
          end

          initial_state = InitialState.find_by_workflow_process_id(travel_workflow_process.id)
          initial_state_id = initial_state&.workflow_state_id
          unless initial_state_id
            # Raise an error if the initial state is not found
            raise "InitialState for workflow process '#{travel_workflow_process.workflow}' not found."
          end

          # 2. Calculate grand total for the Requisition amount
          grand_total = @travel_request.calculate_total_allowance + @travel_request.calculate_total_fuel_cost

          # 3. Create the Requisition record (THIS IS SAVED FIRST)
          requisition = Requisition.new(
            purpose: @travel_request.purpose, # Assuming this is an attr_accessor on TravelRequest
            initiated_by: current_user.id,
            initiated_on: Date.today,
            requisition_type: 'Travel', # Explicitly set for travel requests
            workflow_state_id: initial_state_id,
            project_id: params[:requisition][:project_id]
            # Add department_id here if it's a column on Requisition:
            # department_id: @travel_request.department_id
          )

          unless requisition.save
            # If Requisition fails to save, add errors to travel_request and rollback
            @travel_request.errors.add(:base, "Failed to create Requisition: #{requisition.errors.full_messages.join(', ')}")
            raise ActiveRecord::Rollback
          end

          # 4. Assign the newly created requisition's ID to the travel request
          @travel_request.requisition_id = requisition.id # Assuming Requisition's primary key is 'id'

          # 5. Save the TravelRequest (THIS IS SAVED SECOND)
          unless @travel_request.save
            # If TravelRequest fails to save, add errors and rollback
            @travel_request.errors.add(:base, "Failed to create Travel Request: #{@travel_request.errors.full_messages.join(', ')}")
            raise ActiveRecord::Rollback
          end

          RequisitionItem.create!(
            requisition_id: @travel_request.requisition_id,
            value: grand_total,
            quantity: 1.0,
            item_description: 'Travel Request' # or a more specific description
          )

          # If we reach here, both Requisition and TravelRequest (and Item) are saved successfully
          session[:travel_request_params] = nil # Clear session data
          session[:travel_request_step] = nil
          flash[:notice] = "Travel request created successfully!"
          redirect_to @travel_request # Redirect to the show page of the TravelRequest
        end # End of ActiveRecord::Base.transaction block

      else # Not the last step
        # Merge new params with existing session params to carry data forward
        session[:travel_request_params] = session[:travel_request_params].to_h.merge(travel_request_params.to_h)
        # Advance the step in the session
        session[:travel_request_step] = TravelRequest.steps[TravelRequest.steps.index(@travel_request.current_step) + 1]
        # Redirect to the new action, which will now display the next step
        redirect_to new_travel_request_path
      end
    else # Validation failed for the current step
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::Rollback # Catch the explicit rollback from validation failures
    render :new, status: :unprocessable_entity
  rescue StandardError => e # Catch any other unexpected errors during the process
    flash[:error] = "An unexpected error occurred: #{e.message}"
    Rails.logger.error "Travel Request creation error: #{e.message}\n#{e.backtrace.join("\n")}"
    render :new, status: :unprocessable_entity
  end

  def show
    @requisition = Requisition.find(params[:id])
    prepare_project_options
  end

  # Action for Turbo Frame to dynamically update fuel consumption based on asset selection
  def fuel_consumption
  asset = Asset.find_by(asset_id: params[:asset_id])
  key = asset&.fuel_key
  fuel_property = GlobalProperty.find_by(property: key)
  @fuel_value = fuel_property&.property_value

  Rails.logger.debug "Fuel Key: #{key}"
  Rails.logger.debug "Fuel Value: #{@fuel_value.inspect}"

  render partial: "travel_requests/update_consumption", locals: { fuel: @fuel_value }
end


  private

def prepare_project_options
  @project_options = Project.all.map { |p| [p.project_name, p.id] }
  @selected_project = Project.find_by_short_name(params[:prj])
  @employees = Employee.includes(:person).all.sort_by { |e| e.person.full_name }
end

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
      :return_date,
      :asset_id,
      :purpose, 
      :department,
      # :project_id,
      :unit_fuel_cost,
      :consumption,
      :lunch_allowance,
      :dinner_allowance,
      :accommodation
    )
  end
end
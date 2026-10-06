# frozen_string_literal: true

class EmployeesController < ApplicationController # rubocop:disable Style/Documentation
  before_action :can_access?, only: %i[create edit update show index update_personal_demographics update_employment_details
                                       update_level_of_effort update_supervision record_departure void_record]
  before_action :set_employee, only: %i[update update_personal_demographics update_employment_details update_level_of_effort
                                        update_supervision record_departure void_record]
  def index
    @list_employees = Employee.where(still_employed: true)
  end

  def show
  end

  def new
    @new_employee = Employee.new
  end

  def process_params # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    person_params = params[:person].dup
    employee_params = params[:employee].dup
    supervision_params = params[:supervision].dup

    # Person
    person_params[:first_name] = person_params[:first_name].strip.capitalize.gsub(/[^a-zA-Z]/, '')
    person_params[:middle_name] = person_params[:middle_name].to_s.strip.gsub(/[^a-zA-Z']/, '').capitalize
    person_params[:last_name] = person_params[:last_name].strip.capitalize.gsub(/[^a-zA-Z]/, '')
    person_params[:gender] = person_params[:gender].strip
    person_params[:marital_status] = person_params[:marital_status].strip
    person_params[:primary_phone] = person_params[:primary_phone].strip.gsub(/[^0-9]/, '')
    person_params[:alt_phone] = person_params[:alt_phone].strip.gsub(/[^0-9]/, '')
    person_params[:email_address] = person_params[:email_address].strip
    person_params[:official_email] = person_params[:official_email].to_s.strip.presence
    person_params[:postal_address] = person_params[:postal_address].strip.gsub(/\n/, ',')
    person_params[:residential_address] = person_params[:residential_address].strip.gsub(/\n/, ',')
    person_params[:landmark] = person_params[:landmark].strip.gsub(/\n/, ',')

    # Employee
    employee_params[:branch] = employee_params[:branch].to_i

    # projects
    projects_params = params[:projects].map { |p| p.permit(:project, :allocated_effort) }

    # supervision
    supervisor_name = params[:supervision][:supervisor]
    first_name, last_name = supervisor_name.split(' ', 2)
    supervision_params[:supervisor] = Person.where(first_name: first_name, last_name: last_name)
                                            .pluck(:person_id).first
    supervision_params[:started_on] = params[:supervision][:started_on]

    {
      person: person_params.permit(:first_name, :middle_name, :last_name, :birth_date, :gender, :marital_status,
                                   :primary_phone, :alt_phone, :email_address, :official_email, :postal_address,
                                   :residential_address, :landmark).to_h,

      employee: employee_params.permit(:employment_date, :designated_role, :designation_start_date, :branch,
                                       :departments).to_h,

      supervision: supervision_params.permit(:supervisor, :started_on).to_h,

      project: projects_params

    }
  end

  def create
    begin # rubocop:disable Style/RedundantBegin
      EmployeeCreationService.call(process_params, session)
      UserMailer.welcome_email(session[:last_username], session[:last_password]).deliver_now
      flash[:notice] = 'Employee added successfully!'
      redirect_to '/employees'
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Error updating employee details!: #{e}"
    end
  end

  def edit
    @user = @current_user
    @employee = Employee.find(params[:id])
    @person = @employee.person
    @project = Project.all.collect { |x| [x.project_name, x.id] }
    render :update
  end

  def update_personal_demographics
    Employee::PersonalDemographicsUpdateService.call(@employee, personal_demographics_params)
    redirect_to edit_employee_path(@employee), notice: 'Personal demographics updated successfully.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to edit_employee_path(@employee), alert: e.record.errors.full_messages.to_sentence
  end

  def update_employment_details
    Employee::EmploymentDetailsUpdateService.call(@employee, employment_details_params)
    redirect_to edit_employee_path(@employee), notice: 'Employment details updated successfully.'
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to edit_employee_path(@employee), alert: e.message
  end

  def update_level_of_effort
    Employee::LevelOfEffortUpdateService.call(@employee, level_of_effort_params)
    redirect_to edit_employee_path(@employee), notice: 'Levels of effort updated successfully.'
  rescue ActiveRecord::RecordInvalid, ArgumentError, ActiveRecord::RecordNotFound => e
    redirect_to edit_employee_path(@employee), alert: e.message
  end

  def update_supervision
    Employee::SupervisionUpdateService.call(@employee, supervision_params)
    redirect_to edit_employee_path(@employee), notice: 'Supervision updated successfully.'
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to edit_employee_path(@employee), alert: e.message
  end

  def record_departure
    if current_user.employee_id == @employee.employee_id
      redirect_to employees_path, alert: 'You cannot terminate your own employee record.' and return
    end

    Employee::RecordDepartureService.call(@employee.employee_id, separation_params[:departure_date])
    redirect_to employees_path, notice: 'Employee departure recorded successfully.'
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to employees_path, alert: e.message
  end

  def void_record
    if current_user.employee_id == @employee.employee_id
      redirect_to employees_path, alert: 'You cannot void your own employee record.' and return
    end

    Employee::VoidEmployeeService.call(@employee.employee_id)
    redirect_to employees_path, notice: 'Employee record voided successfully.'
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to employees_path, alert: e.message
  end

  def can_access?
    permitted_users = Designation.where(designated_role: ['Executive Director', 'Administration Officer',
                                                          'Administraton & HR Officer', 'Human Resources Officer', 'Informatics Product Developer']).pluck(:designation_id) # rubocop:disable Layout/LineLength
    current_designation = EmployeeDesignation.where(employee_id: @current_user.employee_id).pluck(:designation_id)
    return unless (current_designation & permitted_users).empty?

    flash[:error] = 'You do not have permission to access this page.'
    redirect_to root_path
  end

  def employee_params
    params.permit(:first_name, :middle_name, :last_name, :birth_date, :gender, :marital_status,
                  :primary_phone, :alt_phone, :email_address, :postal_address, :official_email,
                  :residential_address, :landmark, :employment_date, :designated_role, :supervisor, :started_on,
                  :project, :allocated_effort)
  end

  private

  def set_employee
    @employee = Employee.find_by!(employee_id: params[:id])
  end

  def personal_demographics_params
    params.require(:person).permit(:first_name, :middle_name, :last_name, :birth_date, :gender, :marital_status,
                                   :primary_phone, :alt_phone, :email_address, :official_email, :postal_address,
                                   :residential_address, :landmark)
  end

  def employment_details_params
    params.require(:employee).permit(:employment_date, :designated_role, :designation_start_date, :branch,
                                     :departments, :departure_date)
  end

  def level_of_effort_params
    params.require(:projects).map { |project| project.permit(:project, :allocated_effort) }
  end

  def supervision_params
    params.require(:supervision).permit(:supervisor, :started_on)
  end

  def separation_params
    params.require(:employee).permit(:departure_date)
  end
end

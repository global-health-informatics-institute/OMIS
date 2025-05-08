# frozen_string_literal: true

class EmployeesController < ApplicationController # rubocop:disable Style/Documentation
  before_action :can_access?, only: %i[create edit update show index]
  def index
    @list_employees = Employee.where(still_employed: true).collect { |x| x.person }
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
    person_params[:official_email] = person_params[:official_email].strip
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
    supervision_params[:supervisor] = Person.where(first_name: first_name, last_name: last_name) # rubocop:disable Style/HashSyntax
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
    @person = Person.find(params[:id])
    @employee = Employee.find(params[:id])
    @project = Project.all.collect { |x| [x.project_name, x.id] }
  end

  def update
    @person = Person.find(params[:id])
    @employee = Employee.find(params[:id])
    @designated_role = Designation.where(designated_role: employee_params[:designated_role])
    if @person.update(first_name: params[:person][:first_name], middle_name: params[:person][:middle_name],
                      last_name: params[:person][:last_name],
                      primary_phone: params[:person][:primary_phone], alt_phone: params[:person][:alt_phone],
                      marital_status: params[:person][:marital_status], residential_address: params[:person][:residential_address])
      if @employee.update(employment_date: params[:person][:employment_date])
        if @designated_role.update(designated_role: params[:designated_role])
          redirect_to '/employees'
          flash[:notice] = 'Successfully updated designation.'
        end
        flash[:notice] = 'Successfully updated employee.'
      end
      flash[:notice] = 'Successfully updated person.'
    end
  end

  def can_access?
    permitted_users = Designation.where(designated_role: ['Executive Director', 'Administration Officer',
                                                          'Administraton & HR Officer', 'Human Resources Officer']).pluck(:designation_id)
    current_designation = EmployeeDesignation.where(employee_id: @current_user.id).pluck(:designation_id)
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
end

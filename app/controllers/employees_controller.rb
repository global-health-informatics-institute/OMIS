class EmployeesController < ApplicationController
  def index
    @list_employees = Employee.where(still_employed: true).collect { |x| x.person }
  end

  def show 
  end

  def new
    @new_person = Person.new
    @new_employee = Employee.new
    @new_user = User.new
  end

  def create
    selected_supervisor = employee_params[:supervisor].split(' ')
    supervisor_id = Person.where(first_name: selected_supervisor[0], last_name: selected_supervisor[1])
                          .pluck(:person_id).first
    designated_role = Designation.where(designated_role: employee_params[:designated_role])
                                 .pluck(:designation_id).first

    new_person = Person.new(first_name: employee_params[:first_name], middle_name: employee_params[:middle_name],
                            last_name: employee_params[:last_name], birth_date: employee_params[:birth_date],
                            gender: employee_params[:gender], marital_status: employee_params[:marital_status],
                            primary_phone: employee_params[:primary_phone], alt_phone: employee_params[:alt_phone],
                            email_address: employee_params[:email_address], postal_address: employee_params[:postal_address],
                            official_email: employee_params[:official_email], residential_address: employee_params[:residential_address],
                            landmark: employee_params[:landmark])

    if new_person.save
      new_employee = Employee.new(person_id: new_person.id, employment_date: employee_params[:employment_date])
      if new_employee.save
        new_user = User.new(employee_id: new_employee.id, username: "#{new_person.last_name}#{new_person.first_name[0]}#{rand(999).to_s.rjust(3,"0")}",
                            activated: true, reset_needed: true, activated_at: Time.now, password: 'Q9WKi0f3AHbNZbo2')
        if new_user.save
          new_designation = EmployeeDesignation.new(employee_id: new_employee.id, designation_id: designated_role,
                                                    start_date: new_employee.employment_date)
          if new_designation.save
            new_supervision = Supervision.new(supervisor: supervisor_id, supervisee: new_employee.id, started_on: new_employee.employment_date)
            if new_supervision.save
              employee_params[:project].each do |project|
                project_id = Project.where(short_name: employee_params[:project]).pluck(:project_id).first
                new_project_team = ProjectTeam.new(project_id: project_id, allocated_effort: employee_params[:allocated_effort],
                                                   start_date: new_employee.employment_date, employee_id: new_employee.id)
                if new_project_team.save
                  redirect_to "/employees/new"
                  flash[:notice] = 'Successfully added a person.'
                else
                  flash[:error] = 'Error creating project team.'
                  render :new
                end
              end
            else
              flash[:error] = 'Error creating supervisor.'
              render :new
            end
          else
            flash[:error] = 'Error creating designation.'
            render :new
          end
        else
          flash[:error] = 'Error creating person.'
          render :new
        end
      else
        flash[:error] = 'Error creating employee.'
        render :new
      end
    else
      flash[:error] = 'Error creating person.'
      render :new
    end
  end

  def edit
  end

  def employee_params
    params.require(:person).permit(:first_name, :middle_name, :last_name, :birth_date, :gender, :marital_status,
                                   :primary_phone, :alt_phone, :email_address, :postal_address, :official_email,
                                   :residential_address, :landmark, :employment_date, :designated_role, :supervisor,
                                   :started_on, :project, :allocated_effort)
  end
end

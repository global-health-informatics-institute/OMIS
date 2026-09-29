module ApplicationHelper

  def page_breadcrumb
    return [{ label: "Home", path: root_path }] if controller_name == "main" && action_name == "home"

    labels = {
      "timesheets" => "Timesheet",
      "time_sheet_tasks" => "Timesheet",
      "inventory_items" => "Inventory",
      "business_assets" => "Assets",
      "employees" => "Personnel",
      "requisitions" => "Requisitions",
      "reports" => "Reports",
      "projects" => "Projects"
    }

    [
      { label: "Home", path: root_path },
      { label: labels.fetch(controller_name, controller_name.humanize), path: request.path }
    ]
  end

  def leave_types
    options = ['Annual Leave', 'Compassionate Leave','Maternity Leave','Paternity Leave',
               'Sick Leave', 'Study Leave','Unpaid Leave']
    return options
  end

  def current_timesheet
    if @current_user.blank?
      return ""
    else
      return Timesheet.where(employee_id: @current_user.employee.id,
                      timesheet_week: Date.today.beginning_of_week).first_or_create
    end
  end

  def gender_options
    %w[Male Female TransMale TransFemale Queer Other]
  end

  def marital_options
    %w[Single Married Divorced]
  end
  def bg_colors

  end

  def text_colors

  end

  def projects
    Project.all.collect{|x| x.short_name}
  end

  def roles
    Designation.all.collect{|x| x.designated_role}
  end

  def supervisors
    s = Supervision.all.collect{|x| x.supervisor}
    Person.where(person_id: s).collect{|x| x.first_name + " " + x.last_name}
  end

  def branches
    Branch.all.collect { |x| [x.branch_name, x.id] }
  end

  def departments
    Department.all.collect{|x| x.department_name}
  end
end

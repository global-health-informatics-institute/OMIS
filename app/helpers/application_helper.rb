module ApplicationHelper

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
end

class MainController < ApplicationController
  skip_before_action :logged_in?, only: [:home]
  def home
    if current_user
      @employee = current_user.employee
      @person = @employee.person
      @current_timesheet = Timesheet.where(employee_id: @employee.id,
                                           timesheet_week: Date.today.beginning_of_week).first_or_create
    else
      employees = Employee.where(still_employed: true)
      @gender_summary = Person.where(person_id: employees.collect{|x| x.person_id}).group(:gender).count
    end
  end
end

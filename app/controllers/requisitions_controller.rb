class RequisitionsController < ApplicationController
  def index
  end

  def show

  end

  def new
    @requisition = Requisition.new()
    @selected_request = params["request_type"]

    case @selected_request
    when 'Petty Cash'
      @petty_cash_limit = 500000
    when 'Asset Request'
      @asset_types = AssetCategory.all.collect{|x| x.category}
    when 'Purchase Request'

    when 'Travel Request'
      @employees = Employee.where(still_employed: true).collect{|x| x.person.full_name}
    when 'Personnel Requests'

    when 'Leave Request'
      @annual_leave_bal = LeaveSummary.where(employee_id: current_user.employee.id, 
      leave_type: "Annual Leave", financial_year: Date.today.year).first_or_create

      @sick_leave_bal = LeaveSummary.where(employee_id: current_user.employee.id, 
      leave_type: "Sick Leave", financial_year: Date.today.year).first_or_create

      @compassionate_leave_bal = LeaveSummary.where(employee_id: current_user.employee.id, 
      leave_type: "Compassionate Leave", financial_year: Date.today.year).first_or_create

    end
  end

  def create
  end

  def edit
  end

end

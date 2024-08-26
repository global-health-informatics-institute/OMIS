 class LeaveRequestsController < ApplicationController
  def create
    state_id = InitialState.find_by_workflow_process_id(WorkflowProcess.find_by_workflow('Leave Request')).workflow_state_id
    @leave_request = LeaveRequest.create(leave_type: params[:request_type], employee_id: params[:requester],
                                         start_on: params[:start_date], end_on: params[:end_date],
                                         stand_in: params[:stand_in], status: state_id)
    redirect_to "/leave_requests/#{@leave_request.id}"
  end

  def index
    @employee = current_user.employee
    unused_leave = LeaveSummary.where(employee_id: @employee.id, leave_type: 'Annual Leave',
                                      financial_year: Date.today.year).first
    @remaining_leave_days = ((unused_leave.leave_days_balance.floor(2)) - @employee.used_leave_days)
    @remaining_comp_days = @employee.compensatory_leave
    @remaining_parent_leave  = @employee.paternity_leave

    @annual_summary = []
    @compensatory_summary = []
    @sick_summary = []
    @study_summary = []
    @parent_summary = []
    (1..12).each do |month_number|
      @month_beginning = Date.new(Date.today.year, month_number)
      @month_ending = @month_beginning.end_of_month
      annual_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Annual Leave')
      @annual_summary << annual_summaries
      compensatory_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Compensatory Leave')
      @compensatory_summary << compensatory_summaries
      sick_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Sick Leave')
      @sick_summary << sick_summaries
      study_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Study Leave')
      @study_summary << study_summaries
    #   paternity_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Paternity Leave')
    #   maternity_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Maternity Leave')
    #   @parent_summary << maternity_summaries.empty? ? paternity_summaries : maternity_summaries
    end
  end

  def show

  end

  def update

  end

  def destroy

  end
end

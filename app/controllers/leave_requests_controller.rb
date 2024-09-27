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

    # year = 2024
    # holidays = Holidays.between(Date.new(year, 1, 1), Date.new(year, 12, 31), :mw)
    # raise Holidays.available_regions.inspect

    year_start_date = Date.today.beginning_of_year
    year_end_date = Date.today.end_of_year
    @remaining_leave_days = (@employee.leave_balance(leave_type: 'Annual Leave') - @employee.used_leave_days)
    @remaining_comp_days = @employee.compensatory_leave
    @remaining_parent_leave  = (@employee.leave_balance(leave_type: 'Paternity Leave')) - @employee.used_leave_days(
                                year_start_date, year_end_date,leave_type: 'Paternity Leave')
    @remaining_sick_leave  = (@employee.leave_balance(leave_type: 'Sick Leave')) - @employee.used_leave_days(
      year_start_date, year_end_date,leave_type: 'Sick Leave')
    @remaining_study_leave  = (@employee.leave_balance(leave_type: 'Study Leave')) - @employee.used_leave_days(
      year_start_date, year_end_date,leave_type: 'Study Leave')

    @leave_summary = []
    @yearly_totals = {annual_summary: 0, compensatory_summaries: 0, sick_summary: 0, study_summary: 0,parent_summary: 0,
                     total_leave_days: 0, worked_days: 0}

    (1..12).each do |month_number|
      @month_beginning = Date.new(Date.today.year, month_number)
      @month_ending = @month_beginning.end_of_month
      annual_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Annual Leave')
      compensatory_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Compensatory Leave')
      sick_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Sick Leave')
      study_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Study Leave')
      paternity_summaries = @employee.used_leave_days(@month_beginning, @month_ending,leave_type: 'Paternity Leave')
      total_leave_days = annual_summaries + compensatory_summaries + sick_summaries + study_summaries + paternity_summaries

      leave_projects = Project.where("short_name LIKE ?", "%Leave%").collect{|x| x.id}
      worked_days = TimesheetTask.where("task_date between ? and ? and project_id not in (?)",
                                        @month_beginning, @month_ending, leave_projects).sum('duration')

      @leave_summary << {month: Date::MONTHNAMES[month_number], annual_summary: annual_summaries,
                          compensatory_summaries: compensatory_summaries, sick_summaries:sick_summaries,
                          study_summaries: study_summaries, paternity_summaries: paternity_summaries,
                         total_leave_days: total_leave_days, worked_days: (worked_days/7.5).round(2)}

      @yearly_totals[:annual_summary] += annual_summaries
      @yearly_totals[:compensatory_summaries] += compensatory_summaries
      @yearly_totals[:sick_summary] += sick_summaries
      @yearly_totals[:study_summary] += study_summaries
      @yearly_totals[:parent_summary] += paternity_summaries # add maternity_summaries if applicable
      @yearly_totals[:total_leave_days] += total_leave_days
      @yearly_totals[:worked_days] += (worked_days/7.5).round(2)
    end
    # Holidays.load_custom('/home/ghii/OMIS2/OMIS/config/holidays/mw.yml')
    @holidays = Holidays.between(year_start_date, year_end_date, :mw)
    # @holidays = Holidays.next_holidays(9, [:mw], year_start_date)
    # raise @holidays.inspect

  end

  def show
    @leave_request = LeaveRequest.find(params[:id])
    # raise @leave_request.inspect
    is_owner = (@leave_request.employee_id == current_user.employee_id)
    is_supervisor = current_user.employee.current_supervisees.collect{|x| x.supervisee}.include?(@leave_request.employee_id)
    @possible_actions = possible_actions(@leave_request.status, is_owner, is_supervisor)
  end

  def update

  end

  def destroy

  end

  def approve_leave
    new_state = WorkflowState.where(state: 'Approved',
                                    workflow_process_id: WorkflowProcess.find_by_workflow("Leave Request").id)
    @leave_request = LeaveRequest.where(leave_request_id: params[:id])
                                 .update(reviewed_by: current_user.user_id, reviewed_on: Time.now,
                                         approved_by: current_user.user_id, approved_on: Time.now,
                                         status: new_state.first.id)

    redirect_to "/leave_requests/#{params[:id]}"
  end
  def cancel_leave
    new_state = WorkflowState.where(state: 'Canceled',
                                    workflow_process_id: WorkflowProcess.find_by_workflow("Leave Request").id)
    @leave_request = LeaveRequest.where(leave_request_id: params[:id])
                                 .update(status: new_state.first.id)

    redirect_to "/leave_requests/#{params[:id]}"
  end

  def rescind_request
    new_state = WorkflowState.where(state: 'Rescinded',
                                    workflow_process_id: WorkflowProcess.find_by_workflow("Leave Request").id)
    @leave_request = LeaveRequest.where(leave_request_id: params[:id])
                                 .update(status: new_state.first.id)

    redirect_to "/leave_requests/#{params[:id]}"
  end

  def deny_leave
    new_state = WorkflowState.where(state: 'Rejected',
                                    workflow_process_id: WorkflowProcess.find_by_workflow("Leave Request").id)
    @leave_request = LeaveRequest.where(leave_request_id: params[:id])
                                 .update(status: new_state.first.id)

    redirect_to "/leave_requests/#{params[:id]}"
  end
end

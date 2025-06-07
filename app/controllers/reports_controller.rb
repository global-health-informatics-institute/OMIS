# frozen_string_literal: true
class ReportsController < ApplicationController

  include PdfMonthlyLoeReport
  include XslMonthlyLoeReport
  def index
    # @current_timesheet.timesheet_tasks.select("project_id, task_date, sum(duration) as duration").group('project_id, task_date')
  end

  def show
    @selected_report = params['report_type']
    case @selected_report
    when 'HR'
      hr_report
    when 'Assets'
      assets_report
    when 'Employee LOE'
      monthly_employee_loe_report
    when 'Org LOE'
      monthly_org_loe_report
    when 'Project Report'
      project_progress_report
    when 'Tokens'
      token_requests
    when 'Leave days'
      leave_days
    when 'Petty Cash'
      petty_cash_report
    end
  end

  def new; end

  def create; end

  def edit; end

  private

  def monthly_loe_report; end

  def assets_report; end

  def hr_report; end

  def petty_cash_report
    start_date = params[:start_date]
    end_date = params[:end_date]

    @petty_cash_data = Requisition
                      .includes(:user, :project, :workflow_state)
                      .where(requisition_type: 'Petty Cash')
                      .where(initiated_on: start_date..end_date)
                      .where(workflow_states: { state: 'Liquidated' })
                      .references(:workflow_states)
 respond_to do |format|
  format.turbo_stream

  format.xsl do
    helpers.petty_cash_report_xls(@petty_cash_data, start_date, end_date) do |requisition|
      requisition.used_amount
    end
    send_file('tmp/petty_cash_report.xls',
              filename: "petty_cash_report_#{start_date}_to_#{end_date}.xls")
  end

  format.pdf do
    helpers.petty_cash_report_pdf(@petty_cash_data, start_date, end_date) do |requisition|
      requisition.used_amount
    end
    send_file('tmp/petty_cash_report.pdf',
              filename: "petty_cash_report_#{start_date}_to_#{end_date}.pdf")
  end
end

  end

  def project_progress_report; end

  def leave_days
    start_date = params[:start_date]
    end_date = params[:end_date]
    #@list_employees = Employee.where(still_employed: true).collect { |x| x.person}
    @leave_proj_ids = Project.where('short_name in (?)', ['Annual Leave', 'Compassionate Leave', 'Sick Leave']).collect(&:project_id)
    #req_tasks = TimesheetTask.where(project_id: leave_proj_ids)
    #raise @leave_proj_ids.inspect

    sheets = Timesheet.find_by_sql("SELECT employee_id, project_id, sum(duration) as duration from timesheet_tasks
    as tst inner join (select timesheet_id, employee_id from timesheets where timesheet_week
        BETWEEN '#{Date.parse(params[:start_date])}' and '#{params[:end_date]}') as tt_ts on
            tt_ts.timesheet_id = tst.timesheet_id where tst.project_id in (#{@leave_proj_ids.join(',')}) and tst.task_date 
            BETWEEN '#{params[:start_date]}' and '#{params[:end_date]}' group by employee_id,project_id")

    @people = Person.joins('inner join employees on people.person_id=employees.person_id')
                    .where('employees.employee_id in (?)', sheets.collect(&:employee_id).uniq)
                    .collect { |x| [x.person_id, "#{x.first_name} #{x.last_name}"] }.to_h

    tmp_leave_balances = LeaveSummary.select("employee_id,leave_type, sum(leave_days_total)  as leave_days_total,
                                              sum(leave_days_balance) as leave_days_balance")
                                     .where("employee_id in (?) and financial_year between ? and ? ",
                                            sheets.collect(&:employee_id).uniq, Date.parse(params[:start_date]).year, 
                                            Date.parse(params[:end_date]).year)
                                     .group(:employee_id, :leave_type)

    @leave_balances = {}
    @leave_taken = {}

    (tmp_leave_balances || []).each do |balance|
      if @leave_balances[balance.employee_id].blank?
        @leave_balances[balance.employee_id] = { balance.leave_type => balance.leave_days_total }
      else
        @leave_balances[balance.employee_id][balance.leave_type] = balance.leave_days_total
      end
    end

    (sheets || []).each do |task|
      if @leave_taken[task.employee_id].blank?
        @leave_taken[task.employee_id] = { task.project_id => (task.duration / 7.5).round(2) }
      else
        @leave_taken[task.employee_id][task.project_id] = (task.duration / 7.5).round(2)
      end
    end

    (@people || []).each do |list|
      @taken_test = @leave_taken[list[0]][@leave_proj_ids[0]]
    end

    respond_to do |format|
      format.turbo_stream
      format.xsl do
        helpers.leave_request_report_xls(@people)
        send_file('tmp/leave_request_report.xls',
                  filename: "leave_request_report_#{start_date}_to_#{end_date}.xls")
      end

      format.pdf do
        helpers.leave_request_report_pdf(@people)
        send_file('tmp/leave_request_report.pdf', filename: "petty_cash_report_#{start_date}_to_#{end_date}.pdf")
      end
    end
  end

  def token_requests
    #raise Date.parse(params[:start_date]).inspect
    @tokens = TokenLog.where("created_at >= '#{Date.parse(params[:start_date])}' and created_at <= '#{Date.parse(params[:end_date])}'")
  end

  def monthly_employee_loe_report
    @selected_employee_id = params[:employee_loe_type]
    # raise @selected_employee_id.inspect
    @person = @selected_employee_id.blank? ? Employee.find(current_user.employee_id) : Employee.find(@selected_employee_id)
    # raise params.inspect
    start_day = Date.parse(params[:start_date])
    end_day = Date.parse(params[:end_date])
    @num_of_weeks = (end_day.strftime('%W').to_i - start_day.strftime('%W').to_i) + 1
    sheets = Timesheet.where('employee_id = ? and timesheet_week between ? and ?',
                             @selected_employee_id, start_day.advance(weeks: -1), end_day)
    records = TimesheetTask.where('timesheet_id in (?) and task_date between ? and ? ',
                                  sheets.collect(&:timesheet_id), start_day, end_day)

    @padding = (start_day.cwday.zero? ? 0 : start_day.cwday - 1)

    @days = %w[Sun Mon Tue Wed Thu Fri Sat]
    @first_day = start_day
    @last_day = end_day.day
    @last_date = end_day
    @daily_summary = {}
    @total = 0.0
    (records || []).each do |record|
      if @daily_summary[record.project_id].blank?
        @daily_summary[record.project_id] = { record.task_date.day => record.duration.to_f.floor(2) }
      else
        check = @daily_summary[record.project_id][record.task_date.day]
        @daily_summary[record.project_id][record.task_date.day] =
          (check.blank? ? record.duration.to_f.floor(2) : (check + record.duration.to_f.floor(2)))
      end
      @total += record.duration.round(2)
    end

    respond_to do |format|
      format.turbo_stream
      format.xsl do
        helpers.monthly_loe_report(@daily_summary, @first_day, @last_day, @person)
        send_file('tmp/monthly_employee_loe_report.xls',
                  filename: "#{@person.person.full_name}_monthly_employee_loe_report.xls")
      end

      format.pdf do
        helpers.monthly_employee_loe_pdf(@daily_summary, @first_day, @last_day, @person)
        send_file('tmp/monthly_employee_loe_report.pdf', filename: "#{@person.person.full_name}_monthly_loe_report.pdf")
      end
    end
  end

  def monthly_org_loe_report
    cost_shared_prjs = Project.where('short_name in (?)', ['Crosscutting', 'Public Holiday', 'Annual Leave',
                                                      'Paternity Leave', 'Compassionate Leave', 'Study Leave',
                                                      'Sick Leave']).collect(&:project_id)

    sheets = Timesheet.find_by_sql("SELECT employee_id, project_id, sum(duration) as duration from timesheet_tasks
    as tst inner join (select timesheet_id, employee_id from timesheets where timesheet_week
        BETWEEN '#{Date.parse(params[:start_date]).advance(weeks: -1)}' and '#{params[:end_date]}') as tt_ts on
            tt_ts.timesheet_id = tst.timesheet_id where tst.task_date BETWEEN '#{params[:start_date]}' and
                '#{params[:end_date]}' group by employee_id,project_id")

    @people = Person.joins('inner join employees on people.person_id=employees.person_id')
                    .where('employees.employee_id in (?)', sheets.collect(&:employee_id).uniq)
                    .collect { |x| [x.person_id, "#{x.first_name} #{x.last_name}"] }.to_h

    respond_to do |format|
      format.turbo_stream do
        @results, @cost_shared_hours, @projects_array = helpers.group_by_project(sheets, cost_shared_prjs)
      end
      format.xsl do

        @projects_array = Project.find((sheets.collect(&:project_id).uniq - cost_shared_prjs)).collect { |x| [x.id, x.short_name] }.to_h
        @results, @cost_shared_hours = helpers.group_by_person(sheets, cost_shared_prjs)
        @loes = {}

        (ProjectTeam.where("start_date <= ?  and employee_id in (?) and COALESCE(end_date, '#{Date.today}') >= ? ",
                           params[:start_date], @results.keys, params[:end_date]) || []).each do |loe|
          if @loes[loe.employee_id].blank?
            @loes[loe.employee_id] = {loe.project_id => loe.allocated_effort}
          else
            @loes[loe.employee_id][loe.project_id] = loe.allocated_effort
          end
        end

        file_name = XslMonthlyLoeReport.initialize_report(@people, @results, @projects_array, @cost_shared_hours,
                                                          @loes, params[:start_date], params[:end_date])
        send_file("tmp/#{file_name}", filename: "#{file_name}")
      end
      format.pdf do
        @results, @cost_shared_hours, @projects_array = helpers.group_by_project(sheets, cost_shared_prjs)
        file_name = PdfMonthlyLoeReport.initialize_report(@people, @results, @projects_array, params[:start_date], params[:end_date])
        send_file("tmp/#{file_name}", filename: "#{file_name}")
      end
    end
  end
end

class ReportsController < ApplicationController
  def index
    #@current_timesheet.timesheet_tasks.select("project_id, task_date, sum(duration) as duration").group('project_id, task_date')

  end

  def show
    @selected_report = params["report_type"]
    case @selected_report
    when 'HR'
      hr_report()
    when 'Assets'
      assets_report
    when 'Employee LOE'
      monthly_employee_loe_report()
    when 'Org LOE'
      monthly_org_loe_report
    when 'Project Report'
      project_progress_report
    end
  end
  def new
  end

  def create
  end

  def edit
  end

  private
  def monthly_loe_report

  end
  def assets_report

  end
  def hr_report

  end

  def project_progress_report

  end
  def monthly_employee_loe_report
    if params[:employee].blank?
      @person = Employee.find(current_user.employee_id)
    else
      @person = Employee.find(params[:employee])
    end

    start_day = Date.parse(params[:datetime_ida]).beginning_of_month
    end_day = Date.parse(params[:datetime_ida]).end_of_month
    @num_of_weeks = (end_day.strftime("%W").to_i - start_day.strftime("%W").to_i)+1
    sheets = Timesheet.where("employee_id = ? and timesheet_week between ? and ?",
                             current_user.employee_id, start_day.advance(weeks: -1), end_day)
    records = TimesheetTask.where("timesheet_id in (?) and task_date between ? and ? ",
                                  sheets.collect { |x| x.timesheet_id },start_day, end_day)

    @padding = (start_day.cwday == 0 ? 0 : start_day.cwday-1)

    @days = %w[Sun Mon Tue Wed Thu Fri Sat]
    @first_day = start_day
    @last_day = end_day.day
    @daily_summary = {}
    (records || []).each do |record|
      if @daily_summary[record.project_id].blank?
        @daily_summary[record.project_id] = {record.task_date.day => record.duration.to_f.floor(2)}
      else
        check = @daily_summary[record.project_id][record.task_date.day]
        @daily_summary[record.project_id][record.task_date.day] = (check.blank? ? record.duration.to_f.floor(2) : (check + record.duration.to_f.floor(2)))
      end
    end
  end

  def monthly_org_loe_report
    summaries = Timesheet.find_by_sql("select CONCAT(first_name,' ' ,last_name) as person_name, person_id, short_name,
employee_id, projects.project_id, duration from people inner join (Select employee_id, project_id, sum(duration) as duration
from timesheets t inner join timesheet_tasks tt on
t.timesheet_id = tt.timesheet_id where task_date
BETWEEN '2023-10-26' and '2023-11-25' GROUP BY employee_id, project_id) as summary
on summary.employee_id = people.person_id inner join projects
on projects.project_id = summary.project_id")

    @projects_array = summaries.collect{|x| x['short_name']}.uniq
    @results = {}

    (summaries || []).each do |summary|
      if @results[summary['person_name']].blank?
        @results[summary['person_name']] = Hash[ *@projects_array.collect { |v| [ v, 0.0 ] }.flatten]
      end

      @results[summary['person_name']][summary['short_name']] = summary['duration']
    end
    respond_to do |format|
      format.turbo_stream
      format.xsl do
        helpers.monthly_loe_report(@results, @projects_array)
        send_file("tmp/loe_report.xls", :filename => "nove_loe.xls")
      end
    end
  end
end

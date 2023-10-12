class ReportsController < ApplicationController
  def index
    #@current_timesheet.timesheet_tasks.select("project_id, task_date, sum(duration) as duration").group('project_id, task_date')
    start_day = Date.parse("1-Sep-2023").beginning_of_month
    end_day = Date.parse("1-Sep-2023").end_of_month
    @num_of_weeks = (end_day.strftime("%W").to_i - start_day.strftime("%W").to_i)+1
    sheets = Timesheet.where("employee_id = ? and timesheet_week between ? and ?",
                             current_user.employee_id, start_day, end_day)
    records = TimesheetTask.where(timesheet_id: sheets.collect { |x| x.timesheet_id })
    #records = TimesheetTask.select("project_id,task_date, SUM(duration) as duration").where(
    #  "task_date between ? and ? ", start_day, end_day).group('project_id, task_date')


    @padding = (start_day.cwday == 0 ? 0 : start_day.cwday-1)
    @days = %w[Sun Mon Tue Wed Thu Fri Sat]
    @last_day = end_day.day
    @daily_summary = {}
    (records || []).each do |record|
      if @daily_summary[record.project_id].blank?
        @daily_summary[record.project_id] = {record.task_date.day => record.duration}
      else
        @daily_summary[record.project_id][record.task_date.day] = record.duration
      end
    end

  end

  def new
  end

  def create
  end

  def edit
  end
end

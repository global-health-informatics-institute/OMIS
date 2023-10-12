class ReportsController < ApplicationController
  def index
    #@current_timesheet.timesheet_tasks.select("project_id, task_date, sum(duration) as duration").group('project_id, task_date')
    start_day = Date.parse("1-Sep-2023").beginning_of_month
    end_day = Date.parse("1-Sep-2023").end_of_month
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

  def new
  end

  def create
  end

  def edit
  end
end

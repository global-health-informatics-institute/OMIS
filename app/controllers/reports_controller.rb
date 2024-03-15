# frozen_string_literal: true
class ReportsController < ApplicationController

  include PdfMonthlyLoeReport
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
    end
  end

  def new; end

  def create; end

  def edit; end

  private

  def monthly_loe_report; end

  def assets_report; end

  def hr_report; end

  def project_progress_report; end

  def monthly_employee_loe_report
    @selected_employee_id = params[:employee_loe_type]
    # raise @selected_employee_id.inspect
    @person = @selected_employee_id.blank? ? Employee.find(current_user.employee_id) : Employee.find(@selected_employee_id)

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
    cost_shared = Project.where('short_name in (?)', ['Crosscutting', 'Public Holiday', 'Annual Leave',
                                                      'Paternity Leave', 'Compassionate Leave', 'Study Leave',
                                                      'Sick Leave']).collect(&:project_id)

    sheets = Timesheet.find_by_sql("SELECT employee_id, project_id, sum(duration) as duration from timesheet_tasks
    as tst inner join (select timesheet_id, employee_id from timesheets where timesheet_week
        BETWEEN '#{Date.parse(params[:start_date]).advance(weeks: -1)}' and '#{params[:end_date]}') as tt_ts on
            tt_ts.timesheet_id = tst.timesheet_id where tst.task_date BETWEEN '#{params[:start_date]}' and
                '#{params[:end_date]}' and project_id not in (#{cost_shared.join(',')}) group by employee_id,project_id")

    @results = {}

    (sheets || []).each do |sheet|
      prj_loe = begin
        ProjectTeam.where("start_date <= ? and project_id = ? and employee_id = ? and
           COALESCE(end_date, '#{Date.today}') >= ? ", params[:start_date], sheet.project_id,
                          sheet.employee_id, params[:end_date]).first.allocated_effort
      rescue StandardError
        0.00
      end

      if @results[sheet.project_id].blank?
        @results[sheet.project_id] = [{ employee: sheet.employee_id, hours: sheet.duration, projected_loe: prj_loe }]
      else
        @results[sheet.project_id].append({ employee: sheet.employee_id, hours: sheet.duration,
                                            projected_loe: prj_loe })
      end
    end

    @projects_array = Project.find(@results.keys).collect { |x| [x.id, x.short_name] }.to_h

    @people = Person.joins('inner join employees on people.person_id=employees.person_id')
                    .where('employees.employee_id in (?)', sheets.collect(&:employee_id).uniq)
                    .collect { |x| [x.person_id, "#{x.first_name} #{x.last_name}"] }.to_h

    respond_to do |format|
      format.turbo_stream
      format.xsl do
        # helpers.monthly_loe_report(@results, @projects_array)
        send_file('tmp/loe_report.xls', filename: 'nove_loe.xls')
      end
      format.pdf do
        file_name = PdfMonthlyLoeReport.initialize_report(@people, @results, @projects_array, params[:start_date], params[:end_date])
        send_file("tmp/#{file_name}", filename: "#{file_name}")
      end
    end
  end
end

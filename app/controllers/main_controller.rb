class MainController < ApplicationController
  skip_before_action :logged_in?, only: [:home, :about]
  def home
    if current_user
      @page_title = "User Dashboard"
      @employee = current_user.employee
      @person = @employee.person
      @outstanding_timesheets = Timesheet.select("timesheet_id, employee_id, timesheet_week")
                                         .where("employee_id in (?) and submitted_on is NULL", @employee.id).length
      @unused_leave = LeaveSummary.where(employee_id: @employee.id, leave_type: 'Annual Leave',
                                         financial_year: Date.today.year).first

      #overtime hours calculation
      # overtime_start_date = 6.weeks.ago.to_date
      # end_date = Date.today
      # records = TimesheetTask.where('task_date between ? and ?', overtime_start_date, end_date)
      # total_hours_worked = 0.0
      # weekdays_count = (overtime_start_date..end_date).count { |date| (1..5).include?(date.wday) }
      # working_hours = GlobalProperty.select("property_value")
      #                                .where(property: "number.of.hours")
      #                                .collect(&:property_value).first.to_f
      # records.each do |record|
      #   total_hours_worked += record.duration.round
      # end
      # total_expected_hours = weekdays_count * working_hours
      # total_extra_hours = total_hours_worked - total_expected_hours
      # if total_extra_hours.positive?
      #   @overtime_hours = total_extra_hours
      # else
      #   @overtime_hours = 0.0
      # end

      #taken leave days calculations
      # leave_days_start_date = Date.today.beginning_of_month
      # leave_records = TimesheetTask.where('project_id = ? AND task_date between ? and ?',
      #                                     2, leave_days_start_date, end_date)
      # leave_hours_taken = leave_records.sum { |record| record.duration.round(2)}
      # @leave_days_taken = (leave_hours_taken / 7.5).to_i


      @upcoming_deadlines = ProjectTask.where("project_task_id in (?)",
                                              ProjectTaskAssignment.select(:project_task_id).where(assigned_to: current_user.employee_id,
                                                                          revoked: false )
                                              ).where.not(task_status: "Complete").order("deadline DESC").limit(5)

      @loe_targets = ProjectTeam.where("employee_id = ? and project_id in (?) and end_date is NULL",
                                       current_user.employee_id, Project.select(:project_id).where(is_active: true))
      @unallocated_loe = 100 - @loe_targets.collect { |x| (x.allocated_effort)}.sum
      @project_names = Project.select(:short_name).where(project_id: @loe_targets.collect { |x| x.project_id })
      @loe_current = @employee.loe()

      @total_hrs = 0.0
      (@loe_current || []).each do |k,v|
        @total_hrs += v
      end

      @pending_actions = current_user.employee.pending_actions
      @projects = Project.select(:project_id, :project_name)
      
      #@project_list = ProjectTask.where(voided:false)
      p = Project.where(manager: current_user.employee_id)
      @upcoming_deadlines = []
      p.each do |proj|
        @upcoming_deadlines += proj.upcoming_deadlines
      end

    else
      @page_title = "Application Dashboard"
      people = Employee.select(:employee_id, :person_id).where(still_employed: true)
      @gender_summary, @age_summary = helpers.categorize_employees(
        Person.where(person_id: people.collect{|x|x.person_id}))
      @upcoming_deadlines = ProjectTask.where.not(task_status: "Complete")
      @employment_summary = Hash.new(0)
      @project_tasks = ProjectTask.where(voided:false)
      @retention = ReportStatistic.where(statistic_description: 'Retention Rate')
                                  .order('period_start desc').limit(12)
                                  .collect{|x| [x.period_label, (x.statistic_value*100)]}.to_h

      @turnover = ReportStatistic.where(statistic_description: 'Turnover Rate')
                                 .order('period_start desc').limit(12)
                                 .collect{|x| [x.period_label, (x.statistic_value*100)]}.to_h
      (people || []).each do |person|
        @employment_summary[person.employment_type.to_s] += 1
      end
    end
  end

  def about
    if !current_user.blank?
      @current_timesheet = Timesheet.where(employee_id: current_user.employee_id,
                                           timesheet_week: Date.today.beginning_of_week).first_or_create
    end
  end
end

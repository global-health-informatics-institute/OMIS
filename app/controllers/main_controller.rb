class MainController < ApplicationController
  skip_before_action :logged_in?, only: [:home]
  def home
    if current_user
      @employee = current_user.employee
      @person = @employee.person
      #@current_timesheet = Timesheet.where(employee_id: @employee.id,
      #                                     timesheet_week: Date.today.beginning_of_week).first_or_create
      @upcoming_deadlines = ProjectTask.where("project_task_id in (?)",
                                              ProjectTaskAssignment.select(:project_task_id).where(assigned_to: current_user.employee_id,
                                                                          revoked: false )
                                              ).where.not(task_status: "Complete").order("deadline DESC").limit(5)

      @loe_targets = ProjectTeam.where("employee_id = ? and project_id in (?)", current_user.employee_id, Project.select(:project_id).where(is_active: true))
      @project_names = Project.select(:short_name).where(project_id: @loe_targets.collect { |x| x.project_id })
      @loe_current = TimesheetTask.select("project_id, SUM(duration) as duration").where(
        "task_date between ? and ? ", Date.today.at_beginning_of_month, Date.today.at_end_of_month).group(:project_id)
      @current_prj_names = Project.select(:short_name).where(project_id: @loe_current.collect { |x| x.project_id })

=begin
      #The next block will need to be put in a function as it is repeated elsewhere
      @records = {}
      records = @current_timesheet.timesheet_tasks.select("project_id, task_date,description, sum(duration) as duration").group(
        'project_id, task_date,description').each do |v|
        if @records[v.project_id].blank?
          @records[v.project_id] = {v.description => { v.task_date.cwday => v.duration}}
        elsif @records[v.project_id][v.description].blank?
          @records[v.project_id][v.description] = { v.task_date.cwday => v.duration}
        end
        @records[v.project_id][v.description][v.task_date.cwday] = v.duration
      end
      @projects = Project.where(project_id: records.collect{|p| p.project_id}.uniq).collect { |x| [x.project_id, x.short_name] }.to_h
=end


    else
      people = Employee.where(still_employed: true).pluck(:person_id)
      @gender_summary, @age_summary = helpers.categorize_employees(Person.where(person_id: people))
      @upcoming_deadlines = ProjectTask.where.not(task_status: "Complete")
    end
  end
end

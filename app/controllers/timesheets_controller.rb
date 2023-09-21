class TimesheetsController < ApplicationController
  def index
  end

  def show
    if !params[:period].nil?
      @timesheet = Timesheet.where(timesheet_week: params[:period], employee_id: current_user.employee_id).first_or_create
    else
      @timesheet = Timesheet.find(params[:id])
    end
    @person = Employee.find(@timesheet.employee_id)
    #  @records = @timesheet.timesheet_tasks.select("project_id, task_date,description, sum(duration) as duration").group(
    #  'project_id, task_date,description')


    @records = {}
    records = @timesheet.timesheet_tasks.select("project_id, task_date,description, sum(duration) as duration").group(
      'project_id, task_date,description').each do |v|
      if @records[v.project_id].blank?
        @records[v.project_id] = {v.description => { v.task_date.cwday => v.duration}}
      elsif @records[v.project_id][v.description].blank?
        @records[v.project_id][v.description] = { v.task_date.cwday => v.duration}
      end
      @records[v.project_id][v.description][v.task_date.cwday] = v.duration
    end

    @projects = Project.where(project_id: records.collect{|p| p.project_id}.uniq).collect { |x| [x.project_id, x.short_name] }.to_h
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }
  end
end

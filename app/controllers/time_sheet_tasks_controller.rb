class TimeSheetTasksController < ApplicationController
  def index
  end

  def new
    @time_sheet_id = params[:time_sheet]
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }
  end

  def create
    new_time_sheet_task =  TimesheetTask.create(task_date: params[:task_date], project_id: params[:project_id] ,
                                                timesheet_id: params[:time_sheet_id],
                                                description: params[:description], duration: params[:duration])

    redirect_to "/time_sheets/#{new_time_sheet_task.timesheet_id}"

  end

  def edit
  end
end

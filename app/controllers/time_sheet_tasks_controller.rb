class TimeSheetTasksController < ApplicationController
  def index
  end

  def new
    #raise @date.inspect
    @time_sheet_task = TimesheetTask.find(params[:time_sheet_id]) rescue nil
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }
    @selected_project = Project.find_by_project_name(params[:prj])
  end

  def create    
    new_time_sheet_task =  TimesheetTask.new(task_date: params[:task_date], project_id: params[:project_id] ,
                                                timesheet_id: params[:time_sheet_id],
                                                description: params[:description], duration: params[:duration])
    if new_time_sheet_task.save
      flash[:notice] = "Successfully recorded task in time sheet."
    else
      flash[:error] = "Failed to record task in time sheet."
    end
       
    redirect_to "/time_sheets/#{new_time_sheet_task.timesheet_id}"

  end

  def edit
    @time_sheet_task = TimesheetTask.find(params[:time_sheet_task_id])
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }
  end

  def update
    @time_sheet_task = TimesheetTask.find(params[:id])
    if @time_sheet_task.update(task_date: params[:task_date],
      timesheet_id: params[:time_sheet_id],
      description: params[:description], duration: params[:duration])
      flash[:notice] = "Successfully updated task in time sheet."
      redirect_to "/time_sheets/#{@time_sheet_task.id}"
    else
      flash[:notice] = "Error updating task."
      respond_to do |format|
        format.html { redirect_to "/time_sheets/#{@time_sheet_task.id}" }
        format.js
      end
    end
  end

  def destroy
    @time_sheet_task = TimesheetTask.find(params[:id])
    if @time_sheet_task.destroy
      flash[:alert] = "deleted successfully"
      redirect_to "/time_sheets/#{@time_sheet_task.timesheet_id}"
    else
      flash[:alert] = "error deleting task"
      respond_to do |format|
        format.html { redirect_to timesheet_path(@time_sheet_id.timesheet_id) }
        format.js
      end
    end
  end

  private

  def task_params
    params.require(:time_sheet_task).permit(:description, :project_id, :task_date, :duration, :time_sheet_id)
  end
  
end

class TimeSheetTasksController < ApplicationController
  def index
  end

  def new
    #raise @date.inspect
    @time_sheet_task = TimesheetTask.find(params[:time_sheet_id]) rescue nil
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }
    @selected_project = Project.find_by_short_name(params[:prj])
    @timesheet = Timesheet.find(params[:time_sheet])
  end

  def create    
    new_time_sheet_task =  TimesheetTask.new(task_date: params[:task_date], project_id: params[:project_id] ,
                                                timesheet_id: params[:time_sheet_id],
                                                description: params[:description], duration: params[:duration])
    approved_leave = LeaveRequest.where(status: 31)
    approved_leave
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
    @timesheet = @time_sheet_task.timesheet
  end

  def update
    @time_sheet_task = TimesheetTask.find(params[:id])
    #checking if description has changed
    if @time_sheet_task.description != params[:description] || @time_sheet_task.project_id != params[:project_id]
      old_description = @time_sheet_task.description
      #find all related tasks with the old
      #batch update timesheettask with new description
      if TimesheetTask.where(description: old_description, project_id: @time_sheet_task.project_id,
                             timesheet_id: @time_sheet_task.timesheet_id).update_all(description: params[:description])

        flash[:notice] = "Successfully updated task and related tasks in time sheet."

      end
    end

    if @time_sheet_task.update(project_id: params[:project_id], task_date: params[:task_date],
                               timesheet_id: params[:time_sheet_id],duration: params[:duration])
      flash[:notice] = "Successfully updated task and related tasks in time sheet."
      redirect_to timesheet_path(@time_sheet_task.timesheet_id)
    else
      flash[:error] = "Error updating task."
      redirect_to timesheet_path(@time_sheet_task.timesheet_id)
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
    params.require(:time_sheet_task).permit(:description, :project_id, :task_date, :duration, :time_sheet_id, :time_sheet_task)
  end
  
end

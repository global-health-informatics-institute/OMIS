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

    flash[:notice] = "Successfully recorded task in time sheet."
    redirect_to "/time_sheets/#{new_time_sheet_task.timesheet_id}"

  end

  def edit
    @time_sheet_task = TimesheetTask.find(params[:time_sheet_task_id])
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }
    
    #if @time_sheet_id.nil?
     # flash[:alert] = "Task not found"
     # redirect_to timesheet_path(@time_sheet_id.timesheet_id)
    #end
    #@selected_project_id = @time_sheet_id.project_id  
    #@project_options = Project.all.collect { |x| [x.project_name, x.id] }
    #respond_to do |format|
     # format.html # regular HTML response (rendering a view)
     # format.js   # JavaScript response (for AJAX)
      #end
  end

  def update
    @time_sheet_task = TimesheetTask.find(params[:id])

    
    if @time_sheet_task.update(project_id: params[:project_id], duration: params[:duration], 
      description:  params[:description], task_date:  params[:task_date])
      
      flash[:notice] = "Successfully updated task in time sheet."
      redirect_to "/time_sheets/#{@time_sheet_task.timesheet_id}"
      
    else
      flash[:alert] = "Error updating task."
      respond_to do |format|
        #format.turbo_stream { render turbo_stream: turbo_stream.replace('time_sheet_task', partial: "form")}
        format.html {render :edit}
      end
      
    end
      #respond_to do |format|
       # format.html { redirect_to timesheet_path(@time_sheet_id.timesheet_id) }
        #format.js   # assuming you have an update.js.erb file to handle AJAX response
      #end
    #else
     # flash[:alert] = "Error updating task."
      #render :edit
    #end
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
    params.require(:time_sheet_task).permit(:description, :project_id, :task_date, :duration, :timesheet_id)
  end
  
end

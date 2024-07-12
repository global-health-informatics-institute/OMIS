class TimesheetsController < ApplicationController
  before_action :show
  def index
  end

  def new
  end

  def create
  end

  def edit
  end
  def update
  end
  def destroy
  end
  def show
    if !params[:period].nil?
      week = Date.parse(params[:period]).beginning_of_week.strftime("%Y-%m-%d")
      @timesheet = Timesheet.where(timesheet_week: week, employee_id: current_user.employee_id).first_or_create
    else
      @timesheet = Timesheet.find(params[:id])
    end

    is_owner = (@timesheet.employee_id == current_user.employee_id)
    @possible_actions = WorkflowStateTransition.possible_actions(@timesheet.state, current_user, is_owner)

    @transition_state = WorkflowStateTransition.find_by(workflow_state_id: @timesheet.state)
    #raise @transition_state.next_state.inspect

    @person = Employee.find(@timesheet.employee_id)

    @records = {}
    records = @timesheet.timesheet_tasks.select("project_id, task_date,description, duration, id").each do |v|
      if @records[v.project_id].blank?
        @records[v.project_id] = {v.description => { v.task_date.cwday => v.duration.floor(2)}}
      elsif @records[v.project_id][v.description].blank?
        @records[v.project_id][v.description] = { v.task_date.cwday => v.duration.floor(2)}
      end
      @records[v.project_id][v.description][v.task_date.cwday] = {duration: v.duration.floor(2),id: v.id}
    end

    #raise @records.inspect
    @projects = Project.where(project_id: records.collect{|p| p.project_id}.uniq).collect { |x| [x.project_id, x.short_name] }.to_h
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }

    respond_to do |format|
      format.html
      format.json{render json: @user}
      format.xsl do
        helpers.weekly_spreadsheet(@records, @projects, @timesheet)
        send_file("tmp/timesheet.xls", :filename => "#{@person.person.full_name}.xls")
      end
      format.pdf do
        helpers.weekly_pdf(@records,@projects, @timesheet)
        send_file("tmp/timesheet.pdf", :filename => "#{@person.person.full_name}.pdf")
      end
    end
  end

  def submit_timesheet
    @timesheet = Timesheet.find(params[:id]).update(submitted_on: Time.now(), state: @transition_state.next_state)
    redirect_to "/time_sheets/#{params[:id]}"
  end

  def approve_timesheet
    @timesheet = Timesheet.find(params[:id]).update(approved_on: Time.now(), approved_by: current_user.user_id,
                                                    state: @transition_state.next_state)
    redirect_to "/time_sheets/#{params[:id]}"
  end

  def recall_timesheet
    @timesheet = Timesheet.find(params[:id]).update(submitted_on: nil, state: @transition_state.next_state)
    redirect_to "/time_sheets/#{params[:id]}"
  end

  def resubmit_timesheet
    @timesheet = Timesheet.find(params[:id]).update(submitted_on: Time.now(), state: @transition_state.next_state)
    redirect_to "/time_sheets/#{params[:id]}"
  end
end

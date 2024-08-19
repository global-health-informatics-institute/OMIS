class LeaveRequestsController < ApplicationController
  def create
    state_id = InitialState.find_by_workflow_process_id(WorkflowProcess.find_by_workflow('Leave Request')).workflow_state_id
    @leave_request = LeaveRequest.create(leave_type: params[:request_type], employee_id: params[:requester],
                                         start_on: params[:start_date], end_on: params[:end_date],
                                         stand_in: params[:stand_in], status: state_id)
    redirect_to "/leave_requests/#{@leave_request.id}"
  end

  def index

  end

  def show

  end

  def update

  end

  def destroy

  end
end

class LeaveRequestsController < ApplicationController
  def create
    raise params.inspect
    @leave_request = LeaveRequest.create()
  end
end

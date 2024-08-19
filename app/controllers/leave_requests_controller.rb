class LeaveRequestsController < ApplicationController
  def create
    raise params.inspect
    @leave_request = LeaveRequest.create()
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

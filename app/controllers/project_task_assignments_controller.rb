class ProjectTaskAssignmentsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def revoke # rubocop:disable Metrics/AbcSize
    assignment = ProjectTaskAssignment.joins(:project_task)
                                      .where(project_tasks: { performed_by: current_user.employee_id })
                                      .find(params[:id])

    if assignment.update(revoked: true)
      flash[:notice] = "Task assignment for #{assignment.employee_name} dismissed."
    else
      flash[:alert] = "Could not dismiss task assignment: #{assignment.errors.full_messages.to_sentence}"
    end

    redirect_back fallback_location: root_path
  end
end

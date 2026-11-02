# frozen_string_literal: true

class ProjectTaskAssignmentsController < ApplicationController # rubocop:disable Style/Documentation
  def index; end

  def new; end

  def create; end

  def edit; end

  def revoke
    assignment = ProjectTaskAssignment.find(params[:id])
    employee_name = assignment.employee_name

    # Update the revoked flag to true
    if assignment.update(revoked: true)

      flash[:notice] = "Task for #{employee_name} assignment successfully revoked."
    else
      flash[:error] = 'Could not revoke assignment.'
    end

    redirect_back fallback_location: root_path
  end
end

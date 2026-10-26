# frozen_string_literal: true

class CommitteeMeetingProjectTaskService # rubocop:disable Style/Documentation
  class << self
    def create!(meeting:, chair:, memberships:) # rubocop:disable Metrics/MethodLength
      purchase_request = meeting.purchase_request
      task = ProjectTask.create!(
        project_id: purchase_request.project_id,
        performed_by: chair.employee_id,
        task_description: "IPC for: #{purchase_request.purpose} - #{department_name(purchase_request)}",
        estimated_duration: 1,
        deadline: meeting.scheduled_on.beginning_of_day,
        task_status: :open,
        reference: "/requisitions/purchase_requests/#{purchase_request.requisition_id}"
      )

      memberships.each do |membership|
        ProjectTaskAssignment.create!(
          project_task_id: task.project_task_id,
          assigned_to: membership.employee_id
        )
      end

      task
    end

    private

    def department_name(purchase_request)
      purchase_request.purchase_request_detail.department.department_name
    end
  end
end

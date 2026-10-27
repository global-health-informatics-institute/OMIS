# frozen_string_literal: true

class CommitteeMeetingProjectTaskService # rubocop:disable Style/Documentation
  class << self
    def create!(meeting:, chair:, memberships:) # rubocop:disable Metrics/MethodLength
      purchase_request = meeting.purchase_request
      task = ProjectTask.create!(
        project_id: purchase_request.project_id,
        performed_by: chair.employee_id,
        task_description: "IPC for: #{purchase_request.purpose} - #{project_name(purchase_request)} - #{meeting_time(meeting)}",
        estimated_duration: 1,
        deadline: meeting.scheduled_on,
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

    def project_name(purchase_request)
      purchase_request.project.short_name.presence || purchase_request.project.project_name
    end

    def meeting_time(meeting)
      meeting.scheduled_on.strftime('%H:%M')
    end
  end
end

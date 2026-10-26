# update the state to request an ipc meeting
# frozen_string_literal: true

class PurchaseRequestIpcRouteService # rubocop:disable Style/Documentation
  class << self
    def route_to_ipc(id, committee_id:, meeting_on:, scheduled_by:) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      purchase_request = PurchaseRequest.find(id)
      meeting = purchase_request.committee_meetings.build(
        committee_id: committee_id,
        scheduled_on: meeting_on,
        scheduled_by: scheduled_by
      )
      committee = Committee.active.find_by(committee_id: committee_id)
      members = committee&.active_memberships&.includes(:employee).to_a
      chair = members.find { |membership| membership.role.to_s.casecmp?('chair') }

      transition = WorkflowStateTransition.find_by!(
        workflow_state_id: purchase_request.workflow_state_id,
        action: 'Route to IPC - Vendor Analysis'
      )

      validate_committee_members!(meeting, committee, members, chair)

      ActiveRecord::Base.transaction do
        meeting.save!
        CommitteeMeetingProjectTaskService.create!(meeting:, chair:, memberships: members)
        purchase_request.update!(workflow_state_id: transition.next_state)
      end

      purchase_request
    end

    private

    def validate_committee_members!(meeting, committee, members, chair) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      meeting.valid?

      meeting.errors.add(:committee, 'must be selected and active') unless committee

      meeting.errors.add(:base, 'cannot be scheduled because the committee has no active members') if members.empty?
      meeting.errors.add(:base, 'cannot be scheduled because the committee has no active chair') unless chair
      meeting.errors.add(:base, 'cannot be scheduled because the purchase request has no project') unless meeting.purchase_request.project_id
      unless meeting.purchase_request.purchase_request_detail.department
        meeting.errors.add(:base, 'cannot be scheduled because the purchase request has no department')
      end

      members_without_email = members.reject do |membership|
        person = membership.employee.person
        person.official_email.present? || person.email_address.present?
      end

      if members_without_email.any?
        names = members_without_email.map { |membership| membership.employee.person.full_name }.join(', ')
        meeting.errors.add(:base, "cannot be scheduled because these committee members have no email address: #{names}")
      end

      raise ActiveRecord::RecordInvalid, meeting if meeting.errors.any?
    end
  end
end

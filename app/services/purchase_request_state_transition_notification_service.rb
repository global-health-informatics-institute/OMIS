# frozen_string_literal: true

class PurchaseRequestStateTransitionNotificationService # rubocop:disable Style/Documentation
  class << self
    def call(purchase_request, action_description:)
      new(purchase_request, action_description).call
    end
  end

  def initialize(purchase_request, action_description)
    @purchase_request = purchase_request
    @action_description = action_description
  end

  def call
    sent = []
    sent << notify_requester
    actor_recipients.each { |actor| sent << notify_actor(actor) }
    sent.any?
  end

  private

  def notify_requester
    recipient_email = email_for(requester)
    return false if recipient_email.blank?

    deliver_notification('requester update') do
      PurchaseRequestMailer.requester_state_update(
        @purchase_request,
        requester,
        recipient_email,
        @action_description
      ).deliver_later
    end
  end

  def notify_actor(actor) # rubocop:disable Metrics/MethodLength
    sent = [notify_actor_recipient(actor)]
    return sent.any? unless actor.active_leave?

    stand_in = actor.active_leave_stand_in
    return sent.any? unless stand_in && stand_in.employee_id != actor.employee_id

    sent << notify_actor_recipient(stand_in, stand_in_for: actor)
    sent.any?
  end

  def notify_actor_recipient(recipient, stand_in_for: nil)
    recipient_email = email_for(recipient)
    return false if recipient_email.blank?

    deliver_notification("actor update for employee ##{recipient.employee_id}") do
      PurchaseRequestMailer.review_required(
        @purchase_request,
        requester,
        recipient,
        recipient_email,
        committee_meeting: committee_meeting,
        stand_in_for:
      ).deliver_later
    end
  end

  def deliver_notification(label)
    yield
    true
  rescue StandardError => e
    Rails.logger.error(
      "Purchase request #{label} notification failed for ##{@purchase_request.requisition_id}: #{e.message}"
    )
    false
  end

  def requester
    @requester ||= Employee.find_by(employee_id: @purchase_request.initiated_by)
  end

  def actor_recipients
    @actor_recipients ||= begin
      transitions = WorkflowStateTransition.where(workflow_state_id: @purchase_request.workflow_state_id).to_a
      recipients = []
      recipients << requester if transitions.any?(&:by_owner?)
      recipients.concat(supervisors) if transitions.any?(&:by_supervisor?)
      recipients.concat(designated_actors) if transitions.any? { |transition| !transition.by_owner? && !transition.by_supervisor? }

      recipients.compact.uniq(&:employee_id)
    end
  end

  def supervisors
    Supervision.where(
      supervisee: @purchase_request.initiated_by,
      ended_on: nil,
      is_terminated: false
    ).includes(:supervisor_employee).filter_map(&:supervisor_employee)
  end

  def designated_actors
    return committee_members if @purchase_request.current_state == 'Pending IPC - Vendor Analysis'

    designation_ids = WorkflowStateActor.where(workflow_state_id: @purchase_request.workflow_state_id)
                                         .pluck(:employee_designation_id)
    return [] if designation_ids.empty?

    Employee.joins(:employee_designations)
            .where(still_employed: true, employee_designations: { designation_id: designation_ids, end_date: nil })
            .distinct
  end

  def committee_members
    return [] unless committee_meeting

    committee_meeting.committee.active_memberships.includes(:employee).map(&:employee)
  end

  def committee_meeting
    return unless @purchase_request.current_state == 'Pending IPC - Vendor Analysis'

    @committee_meeting ||= @purchase_request.committee_meetings.scheduled.order(scheduled_on: :desc).first
  end

  def email_for(employee)
    person = employee&.person
    person&.official_email.presence || person&.email_address
  end
end

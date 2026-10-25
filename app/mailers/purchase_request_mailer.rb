# frozen_string_literal: true

class PurchaseRequestMailer < ApplicationMailer # rubocop:disable Style/Documentation
  def requester_state_update(purchase_request, requester, recipient_email, action_description)
    @purchase_request = purchase_request
    @requester_name = requester&.person&.full_name || 'Requester'
    @current_state = purchase_request.current_state
    @action_description = action_description

    mail(
      to: recipient_email,
      subject: "Purchase Request ##{purchase_request.requisition_id}: #{@current_state}"
    )
  end

  def review_required(purchase_request, requester, actor, recipient_email)
    @purchase_request = purchase_request
    @requester_name = requester&.person&.full_name || 'the requester'
    @actor_name = actor.person.full_name
    @current_state = purchase_request.current_state

    mail(
      to: recipient_email,
      subject: "Purchase Request ##{purchase_request.requisition_id} Requires Your Action"
    )
  end
end

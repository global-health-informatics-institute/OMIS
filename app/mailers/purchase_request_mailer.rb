# frozen_string_literal: true

class PurchaseRequestMailer < ApplicationMailer # rubocop:disable Style/Documentation
  def requester_state_update(purchase_request, requester, recipient_email, action_description)
    @purchase_request = purchase_request
    @requester_name = requester&.person&.full_name || 'Requester'
    @current_state = purchase_request.current_state
    @action_description = action_description

    mail(
      to: recipient_email,
      subject: "Purchase Request Update: #{@current_state}"
    )
  end

  def review_required(purchase_request, requester, actor, recipient_email, committee_meeting: nil)
    @purchase_request = purchase_request
    @requester_name = requester&.person&.full_name || 'the requester'
    @actor_name = actor.person.full_name
    @current_state = purchase_request.current_state
    @committee_meeting = committee_meeting

    mail(
      to: recipient_email,
      subject: 'Purchase Request Requires Your Action'
    )
  end

  def lpo_documents(purchase_request, recipient_email, cc_emails, signed_lpo_path, unsigned_lpo_path) # rubocop:disable Metrics/AbcSize
    @purchase_request = purchase_request
    @requester_name = purchase_request.initiator&.person&.full_name || 'the requester'
    @recipient_name = purchase_request.purchase_request_detail.lpo_ed_approver&.person&.full_name || 'Executive Director'

    attachments["signed_lpo_#{purchase_request.requisition_id}.pdf"] = File.binread(signed_lpo_path)
    attachments["unsigned_lpo_#{purchase_request.requisition_id}.pdf"] = File.binread(unsigned_lpo_path)

    mail(
      to: recipient_email,
      cc: cc_emails,
      subject: "LPO documents: #{purchase_request.purpose}"
    )
  end
end

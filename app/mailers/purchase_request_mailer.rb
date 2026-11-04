# frozen_string_literal: true

class PurchaseRequestMailer < ApplicationMailer # rubocop:disable Style/Documentation
  def requester_state_update(purchase_request, requester, recipient_email, action_description)
    @purchase_request = purchase_request
    @requester_name = requester&.person&.full_name || 'Requester'
    @current_state = purchase_request.current_state
    @action_description = action_description
    @submitted_on = purchase_request.initiated_on || purchase_request.created_at.to_date

    mail(
      to: recipient_email,
      subject: "Purchase Request Status Update: #{@current_state}"
    )
  end

  def review_required( # rubocop:disable Metrics/ParameterLists,Metrics/MethodLength
    purchase_request,
    requester, actor,
    recipient_email,
    committee_meeting: nil,
    stand_in_for: nil
  )
    @purchase_request = purchase_request
    @requester_name = requester&.person&.full_name || 'the requester'
    @actor_name = actor.person.full_name
    @current_state = purchase_request.current_state
    @committee_meeting = committee_meeting
    @stand_in_for_name = stand_in_for&.person&.full_name
    @submitted_on = purchase_request.initiated_on || purchase_request.created_at.to_date

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

  def payment_voucher_documents( # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    purchase_request,
    recipient_email,
    cc_emails,
    signed_payment_voucher_path,
    unsigned_payment_voucher_path
  )
    @purchase_request = purchase_request
    @requester_name = purchase_request.initiator&.person&.full_name || 'the requester'
    @recipient_name = purchase_request.purchase_request_detail.payment_request_ed_approver&.person&.full_name || 'Executive Director' # rubocop:disable Layout/LineLength

    attachments["signed_payment_voucher_#{purchase_request.requisition_id}.pdf"] =
      File.binread(signed_payment_voucher_path)
    attachments["unsigned_payment_voucher_#{purchase_request.requisition_id}.pdf"] =
      File.binread(unsigned_payment_voucher_path)

    mail(
      to: recipient_email,
      cc: cc_emails,
      subject: "Payment voucher documents: #{purchase_request.purpose}"
    )
  end
end

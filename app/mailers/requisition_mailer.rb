class RequisitionMailer < ApplicationMailer
  default from: 'omis@ghii.org'
  def reject_request_email(requisition)
    @requisition = requisition
    @user = @requisition.user # Assign to instance variable for the view
    @person = @user.person # Assign parameter to instance variable

    # Get the initiator's email through associations
    user = @requisition.user
    receiver_email = user.person.email_address 

    Rails.logger.info "Sending email to: #{receiver_email} for requisition ##{@requisition.requisition_id}"

    mail(
      to: receiver_email,
      subject: "Your Requisition ##{@requisition.id} Has Been rejected"
    )
  end
  def funds_approved_email(requisition)
    @requisition = requisition
    @user = @requisition.user 
    @person = @user.person 

    # Get the initiator's email through associations
    user = @requisition.user
    receiver_email = user.person.email_address 

    Rails.logger.info "Sending email to: #{receiver_email} for requisition ##{@requisition.requisition_id}"

    mail(
      to: receiver_email,
      subject: "Your Requisition ##{@requisition.id} Has Been Approved"
    )
  end
end

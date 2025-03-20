class RequisitionMailer < ApplicationMailer
  default from: "omis@ghii.org"  # Ensure emails are sent from this address

  def approval_email(requisition)
    @requisition = requisition
    @user = @requisition.requested_by  # Ensure requisition has a `requested_by` association

    mail(
      to: @user.email, 
      subject: "Your Requisition ##{@requisition.id} Has Been Approved"
    )
  end
end

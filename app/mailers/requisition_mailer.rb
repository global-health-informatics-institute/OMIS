class RequisitionMailer < ApplicationMailer
end
class RequisitionMailer < ApplicationMailer
  default from: "omis@ghii.org"  # Ensure emails are sent from this address

  def funds_approved_email(requisition)
    @requisition = requisition
    @user = Person.find(@requisition.initiated_by) # Ensure requisition has a `requested_by` association

    mail(
      to: @user.email_address, 
      subject: "Your Requisition ##{@requisition.id} Has Been Approved"
    )
  end
end

class RequisitionMailer < ApplicationMailer
  default from: 'omis@ghii.org'
  def notify_supervisor(requisition, supervisor)
    @requisition = requisition
    @supervisor = supervisor
    @requester = Employee.find_by(employee_id: requisition.initiated_by)

    mail(to: @supervisor.person.email_address, subject: 'New Requisition Requires Your Review') 
  end
  def notify_admin(requisition, admin)
    @requisition = requisition
    @admin = admin
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    @supervisor = User.find_by(user_id: @requisition.reviewed_by) if @requisition.reviewed_by.present?
    mail(to: @admin.person.email_address, subject: 'New Requisition Requires Your Review') 
    
  end
  def resubmitted_mail(requisition, supervisor)
    @requisition = requisition
    @supervisor = supervisor
    @requester = Employee.find_by(employee_id: requisition.initiated_by)

    mail(to: @supervisor.person.email_address, subject: 'New Requisition Requires Your Review') 
  end

  def rejected_request_email(requisition)
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

  def request_approved_email(requisition)
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

  def funds_denied_email(requisition)
    @requisition = requisition
    @user = @requisition.user
    @person = @user.person

    # Get the initiator's email through associations
    user = @requisition.user
    receiver_email = user.person.email_address

    Rails.logger.info "Sending email to: #{receiver_email} for requisition ##{@requisition.requisition_id}"

    mail(
      to: receiver_email,
      subject: "Your Requisition Funds ##{@requisition.id} Has Been Denied"
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
      subject: "Your Requisition Funds ##{@requisition.id} Has Been Approved"
    )
  end
end

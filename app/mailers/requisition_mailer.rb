class RequisitionMailer < ApplicationMailer
  default from: 'omis@ghii.org'
  def notify_supervisor(requisition, supervisor)
    @requisition = requisition
    @supervisor = supervisor
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    recipient_email = @supervisor.person.official_email || @supervisor.person.email_address

    mail(to: recipient_email, subject: 'New Requisition Requires Your Review') 
  end
  def notify_admin(requisition, admin)
    @requisition = requisition
    @admin = admin
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    @supervisor_name = @requisition.reviewer# Get the stored first name
  
    recipient_email = @admin.person.official_email.presence || @admin.person.email_address
  
    mail(to: recipient_email, subject: 'New Requisition Requires Your Review')
  end
  
  def resubmitted_mail(requisition, supervisor)
    @requisition = requisition
    @supervisor = supervisor
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    receiver_email = @supervisor.person.official_email || @supervisor.person.email_address

    mail(to: receiver_email, subject: 'New Requisition Requires Your Review') 
  end
  def notify_admin(requisition, admin)
    @requisition = requisition
    @admin = admin
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    @supervisor_name = @requisition.reviewed_by # Get the stored first name
  
    recipient_email = @admin.person.official_email.presence || @admin.person.email_address
  
    mail(to: recipient_email, subject: 'New Requisition Requires Your Review')
  end
  
  def resubmitted_mail(requisition, supervisor)
    @requisition = requisition
    @supervisor = supervisor
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    receiver_email = @supervisor.person.official_email || @supervisor.person.email_address

    mail(to: receiver_email, subject: 'New Requisition Requires Your Review') 
  end

  def rejected_request_email(requisition)
    @requisition = requisition
    @user = @requisition.user # Assign to instance variable for the view
    @person = @user.person # Assign parameter to instance variable

    # Get the initiator's email through associations
    user = @requisition.user
    receiver_email = user.person.official_email || user.person.email_address

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
    receiver_email = user.person.official_email || user.person.email_address

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
    receiver_email = user.person.official_email || user.person.email_address

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
    receiver_email = user.person.official_email || user.person.email_address

    Rails.logger.info "Sending email to: #{receiver_email} for requisition ##{@requisition.requisition_id}"

    mail(
      to: receiver_email,
      subject: "Your Requisition Funds ##{@requisition.id} Has Been Approved"
    )
  end
  def timesheet_rejected_mail(timesheet, rejection_reason) 
    @timesheet = timesheet
    @employee = @timesheet.employee
    @person = @employee.person
    @rejection_comment_for_email = rejection_reason 
    receiver_email = @person.official_email || @person.email_address# Assuming User has a 'person' association

    receiver_email = @person.official_email || @person.email_address

    Rails.logger.info "Sending email to: #{receiver_email} for timesheet ##{@timesheet.id}"

    mail(
      to: receiver_email,
      subject: "Your Timesheet ##{@timesheet.id} Has Been Rejected"
    )
  end
end

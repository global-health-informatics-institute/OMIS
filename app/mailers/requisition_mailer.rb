class RequisitionMailer < ApplicationMailer
  default from: 'mkhalipiwatipatso@gmail.com'
  def notify_supervisor(requisition, supervisor)
    @requisition = requisition
    @supervisor = supervisor
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    recipient_email = @supervisor.person.official_email || @supervisor.person.email_address

    mail(to: recipient_email, subject: 'New Requisition Requires Your Review') 
  end
  
  def notify_supervisor_purchase_request(requisition, supervisor)
    @requisition = requisition
    @supervisor = supervisor
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    recipient_email = @supervisor.person.official_email || @supervisor.person.email_address

    mail(to: recipient_email, subject: 'New Purchase Request Requires Your Review') 
  end
  
  def purchase_request_approved_email(requisition)
    @requisition = requisition
    @user = @requisition.user
    @person = @user.person

    # Get the initiator's email through associations
    user = @requisition.user
    receiver_email = user.person.official_email || user.person.email_address

    Rails.logger.info "Sending purchase request approval email to: #{receiver_email} for requisition ##{@requisition.id}"

    mail(
      to: receiver_email,
      subject: "Your Purchase Request ##{@requisition.id} Has Been Approved"
    )
  end
  
  def notify_admin_purchase_request(requisition, admin)
    @requisition = requisition
    @admin = admin
    @requester = Employee.find_by(employee_id: requisition.initiated_by)
    @supervisor_name = @requisition.reviewer # Get the stored first name
  
    recipient_email = @admin.person.official_email.presence || @admin.person.email_address
  
    mail(to: recipient_email, subject: 'Purchase Request Approved - Procurement Action Required')
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
  def notify_ipc_members(requisition, employee, meeting_date, meeting_time)
  @requisition = requisition
  @employee = employee
  @meeting_date = meeting_date
  @meeting_time = meeting_time
  @requester = Employee.find_by(employee_id: requisition.initiated_by)

  recipient_email = @employee.person.official_email || @employee.person.email_address

  mail(
    to: recipient_email,
    subject: "IPC Meeting Invitation for Requisition ##{requisition.id}"
  )
 end

 def item_delivered_email(requisition, item_description)
  @requisition = requisition
  @item_description = item_description
  @requester = Employee.find_by(employee_id: requisition.initiated_by)
  
  recipient_email = @requester.person.official_email || @requester.person.email_address

  mail(
    to: recipient_email,
    subject: "Your #{@item_description} has been delivered"
  )
 end
end

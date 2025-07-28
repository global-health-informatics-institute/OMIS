class RequisitionMailer < ApplicationMailer
  default from: 'omis@ghii.org'
include ActionView::Helpers::NumberHelper  
  
  def request_petty_cash(requisition, supervisor)
  @requisition = requisition
  @requisition_details = {
    amount: number_to_currency(requisition.requisition_items.sum(&:value), unit: 'MWK'),
    purpose: requisition.purpose,
    requester_name: Employee.find_by(employee_id: requisition.initiated_by)&.person&.full_name,
    supervisor_full_name: Employee.find_by(employee_id: requisition.reviewed_by)&.person&.full_name || 
                         supervisor.person.full_name,
    created_at: requisition.created_at.strftime('%b %d, %Y at %I:%M %p')
  }
  
  recipient_email = supervisor.person.official_email || supervisor.person.email_address
  mail(to: recipient_email, subject: 'New Requisition Requires Your Review')
end
  def request_funds_petty_cash(requisition, admin)
    @requisition = requisition
    @admin = admin
      @requisition_details = {
       amount: number_to_currency(requisition.requisition_items.sum(&:value), unit: 'MWK'),
       purpose: requisition.purpose,
       project: requisition.project.project_name,
       requester_name: Employee.find_by(employee_id: requisition.initiated_by)&.person&.full_name,
       supervisor_full_name: Employee.find_by(employee_id: requisition.reviewed_by)&.person&.full_name || 
                         supervisor.person.full_name,
    created_at: requisition.created_at.strftime('%b %d, %Y at %I:%M %p'),
    admin_full_name: Employee.find_by(employee_id: requisition.approved_by)&.person&.full_name ||@admin.person.last_name
  }
  
    recipient_email = @admin.person.official_email.presence || @admin.person.email_address
  
    mail(to: recipient_email, subject: 'New Requisition Requires Your Review')
  end
  
  def resubmitted_mail(requisition, supervisor)
   @requisition = requisition
  @requisition_details = {
    amount: number_to_currency(requisition.requisition_items.sum(&:value), unit: 'MWK'),
    purpose: requisition.purpose,
    requester_name: Employee.find_by(employee_id: requisition.initiated_by)&.person&.full_name,
    supervisor_full_name: Employee.find_by(employee_id: requisition.reviewed_by)&.person&.full_name || 
                         supervisor.person.full_name,
    created_at: requisition.created_at.strftime('%b %d, %Y at %I:%M %p')
    }
  
    recipient_email = supervisor.person.official_email || supervisor.person.email_address
    mail(to: recipient_email, subject: 'New Requisition Requires Your Review')
  end

  def rejected_request_email(requisition)
    @requisition = requisition
    @user = @requisition.user # Assign to instance variable for the view
    @person = @user.person # Assign parameter to instance variable

    # Get the initiator's email through associations
    user = @requisition.user
    receiver_email = user.person.official_email || user.person.email_address
    supervisor = Employee.find_by(employee_id: requisition.reviewed_by)
    @requisition_details ={
      requester_name: Employee.find_by(employee_id: requisition.initiated_by)&.person&.full_name,
      supervisor_full_name: Employee.find_by(employee_id: requisition.reviewed_by)&.person&.full_name || 
                         supervisor.person.full_name
    }

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
    @requisition_details ={
      requester_name: Employee.find_by(employee_id: requisition.initiated_by)&.person&.full_name,
      supervisor_full_name: Employee.find_by(employee_id: requisition.reviewed_by)&.person&.full_name || 
                         supervisor.person.full_name
    }

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
    @requisition_details ={
      requester_name: Employee.find_by(employee_id: requisition.initiated_by)&.person&.full_name,
      supervisor_full_name: Employee.find_by(employee_id: requisition.reviewed_by)&.person&.full_name || 
                         supervisor.person.full_name
    }

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
    @requisition_details ={
      requester_name: Employee.find_by(employee_id: requisition.initiated_by)&.person&.full_name,
      supervisor_full_name: Employee.find_by(employee_id: requisition.reviewed_by)&.person&.full_name || 
                         supervisor.person.full_name
    }

    Rails.logger.info "Sending email to: #{receiver_email} for requisition ##{@requisition.requisition_id}"

    mail(
      to: receiver_email,
      subject: "Your Requisition Funds ##{@requisition.id} Has Been Approved"
    )
  end
end

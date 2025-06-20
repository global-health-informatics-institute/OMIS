# frozen_string_literal: true

class LeaveRequestMailer < ApplicationMailer # rubocop:disable Style/Documentation
  default from: 'communications@ghii.org'

  def leave_request(leave) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/PerceivedComplexity,Metrics/MethodLength
    requester_id = leave[:employee_id]
    puts
    @leave_details = {
      leave_type: leave[:leave_type],
      leave_id: leave[:leave_request_id],
      duration: "starting on #{leave[:start_on]&.strftime('%B %d, %Y') || 'N/A'} ending on #{leave[:end_on]&.strftime('%B %d, %Y') || 'N/A'}", # rubocop:disable Layout/LineLength
      requester_full_name: Employee.find_by_employee_id(requester_id)&.person&.full_name,
      supervisor_full_name: Employee.find_by_employee_id(requester_id)&.supervisor&.person&.full_name,
      supervisor_email: Employee.find_by_employee_id(requester_id)&.supervisor&.person&.official_email.presence || Employee.find_by_employee_id(requester_id)&.supervisor&.person&.email_address, # rubocop:disable Layout/LineLength
      requester_id:,
      supervisor_id: Employee.find_by_employee_id(requester_id)&.supervisor&.user&.user_id
    }
    puts "LEAVE DETAILS: #{leave.inspect}"
    mail(
      to: @leave_details[:supervisor_email],
      subject: "#{@leave_details[:leave_type]} Request from #{@leave_details[:requester_full_name]}"
    )
  end
end

# frozen_string_literal: true

class LeaveRequestMailer < ApplicationMailer # rubocop:disable Style/Documentation,Metrics/ClassLength
  default from: 'communications@ghii.org'

  def leave_request(leave) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/PerceivedComplexity,Metrics/MethodLength
    requester_id = leave[:employee_id]
    @leave_details = {
      leave_type: leave[:leave_type],
      leave_id: leave[:leave_request_id],
      duration: "starting on #{leave[:start_on]&.strftime('%B %d, %Y at %I:%M %p') || 'N/A'} ending on #{leave[:end_on]&.strftime('%B %d, %Y at %I:%M %p') || 'N/A'}", # rubocop:disable Layout/LineLength
      requester_full_name: Employee.find_by_employee_id(requester_id)&.person&.full_name,
      supervisor_full_name: Employee.find_by_employee_id(requester_id)&.supervisor&.person&.full_name,
      supervisor_email: Employee.find_by_employee_id(requester_id)&.supervisor&.person&.official_email.presence || Employee.find_by_employee_id(requester_id)&.supervisor&.person&.email_address, # rubocop:disable Layout/LineLength
      requester_id:,
      supervisor_id: Employee.find_by_employee_id(requester_id)&.supervisor&.user&.user_id,
      leave_stand_in: LeaveRequest.find(leave.id).leave_stand_in,
      leave_balance: LeaveRequest.find(leave.id).leave_balance
    }
    mail(
      to: @leave_details[:supervisor_email],
      subject: "#{@leave_details[:leave_type]} Request from #{@leave_details[:requester_full_name]}"
    )
  end

  def approve_leave_request(leave) # rubocop:disable Metrics/...
    leave = leave.first if leave.is_a?(Array)
    leave = leave.attributes unless leave.is_a?(Hash)
    leave = leave.transform_keys(&:to_sym) if leave.is_a?(Hash)
    @leave_details = {
      leave_type: leave[:leave_type],
      leave_id: leave[:leave_request_id],
      duration: "starting on #{leave[:start_on]&.strftime('%B %d, %Y') || 'N/A'} ending on #{leave[:end_on]&.strftime('%B %d, %Y') || 'N/A'}",
      requester_full_name: Employee.find_by_employee_id(leave[:employee_id])&.person&.full_name,
      requester_email: Employee.find_by_employee_id(leave[:employee_id])&.person&.official_email.presence || Employee.find_by_employee_id(leave[:employee_id])&.person&.email_address,
      reviewer_full_name: Employee.find_by_employee_id(leave[:reviewed_by])&.person&.full_name,
      reviewer_email: Employee.find_by_employee_id(leave[:reviewed_by])&.person&.official_email.presence || Employee.find_by_employee_id(leave[:reviewed_by])&.person&.email_address
    }
    mail(
      to: @leave_details[:requester_email],
      subject: "#{@leave_details[:leave_type]} Request Approved"
    )
  end

  def team_broadcast_approved_leave_request(leave) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    leave = leave.first if leave.is_a?(Array)
    leave = leave.attributes unless leave.is_a?(Hash)
    leave = leave.transform_keys(&:to_sym) if leave.is_a?(Hash)
    @leave_details = {
      leave_type: (leave[:leave_type]).downcase.include?('leave') ? leave[:leave_type] : "#{leave[:leave_type]} Leave",
      leave_id: leave[:leave_request_id],
      duration_start: (leave[:start_on]&.strftime('%I:%M %p, %B %d, %Y') || 'N/A').to_s,
      duration_end: (leave[:end_on]&.strftime('%I:%M %p, %B %d, %Y') || 'N/A').to_s,
      requester_full_name: Employee.find_by_employee_id(leave[:employee_id])&.person&.full_name,
      leave_stand_in: Employee.find_by(employee_id: leave[:stand_in])&.person&.full_name,
      recepient_list: create_cc(leave[:employee_id]),
      recepient_full_name: 'Colleagues'
    }
    return unless @leave_details[:recepient_list].present?

    mail(
      cc: @leave_details[:recepient_list].map { |_, details| details[:email] }.join(', '),
      subject: "Out Of Office Notice - #{@leave_details[:requester_full_name]}"
    )
  end

  def broadcast_approved_leave_request(leave) # rubocop:disable Metrics/...
    leave = leave.first if leave.is_a?(Array)
    leave = leave.attributes unless leave.is_a?(Hash)
    leave = leave.transform_keys(&:to_sym) if leave.is_a?(Hash)
    @leave_details = {
      leave_type: (leave[:leave_type]).downcase.include?('leave') ? leave[:leave_type] : "#{leave[:leave_type]} Leave",
      leave_id: leave[:leave_request_id],
      duration_start: (leave[:start_on]&.strftime('%I:%M %p, %B %d, %Y') || 'N/A').to_s,
      duration_end: (leave[:end_on]&.strftime('%I:%M %p, %B %d, %Y') || 'N/A').to_s,
      requester_full_name: Employee.find_by_employee_id(leave[:employee_id])&.person&.full_name,
      leave_stand_in: Employee.find_by(employee_id: leave[:stand_in])&.person&.full_name,
      requester_email: Employee.find_by_employee_id(leave[:employee_id])&.person&.official_email.presence ||
                       Employee.find_by_employee_id(leave[:employee_id])&.person&.email_address,
      recepient_full_name: 'All',
      receipient_email: GlobalProperty.find_by(property: 'approved_email_group').property_value
    }
    mail(
      to: @leave_details[:receipient_email],
      subject: "Out Of Office Notice - #{@leave_details[:requester_full_name]}"
    )
  end

  def deny_leave_request(leave) # rubocop:disable Metrics/...
    leave = leave.first if leave.is_a?(Array)
    leave = leave.attributes unless leave.is_a?(Hash)
    leave = leave.transform_keys(&:to_sym) if leave.is_a?(Hash)
    @leave_details = {
      leave_type: leave[:leave_type],
      leave_id: leave[:leave_request_id],
      duration: "starting on #{leave[:start_on]&.strftime('%B %d, %Y') || 'N/A'} ending on #{leave[:end_on]&.strftime('%B %d, %Y') || 'N/A'}", # rubocop:disable Layout/LineLength
      requester_full_name: Employee.find_by_employee_id(leave[:employee_id])&.person&.full_name,
      requester_email: Employee.find_by_employee_id(leave[:employee_id])&.person&.official_email.presence || Employee.find_by_employee_id(leave[:employee_id])&.person&.email_address, # rubocop:disable Layout/LineLength
      reviewer_full_name: Employee.find_by_employee_id(leave[:reviewed_by])&.person&.full_name,
      reviewer_email: Employee.find_by_employee_id(leave[:reviewed_by])&.person&.official_email.presence || Employee.find_by_employee_id(leave[:reviewed_by])&.person&.email_address # rubocop:disable Layout/LineLength
    }
    mail(
      to: @leave_details[:requester_email],
      subject: "#{@leave_details[:leave_type]} Request Denied"
    )
  end

  def create_cc(employee_id) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    employee_id_set = Set.new
    employee = Employee.find_by_employee_id(employee_id)

    # Get all supervisees of the employee
    immediate_supervisees = employee&.given_supervisions&.map(&:supervisee)
    employee_id_set.merge(immediate_supervisees) if immediate_supervisees.present?

    # Get all supervisees of the employee's supervisor (co-employees)
    immediate_supervisor = employee&.supervisor
    co_employees = immediate_supervisor&.given_supervisions&.map(&:supervisee)
    employee_id_set.merge(co_employees) if co_employees.present?

    # Remove supervisor and requester from cc list
    employee_id_set.delete(employee_id)
    employee_id_set.delete(employee&.supervisor&.employee_id)

    return [] if employee_id_set.empty?

    # create a dictionary of employee_id and email
    Employee.where(employee_id: employee_id_set.to_a).map do |x|
      [
        x.employee_id,
        {
          full_name: x.person&.full_name,
          email: x.person&.official_email.presence || x.person&.email_address
        }
      ]
    end.to_h
  end
end

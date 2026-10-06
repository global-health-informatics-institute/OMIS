# frozen_string_literal: true

class Employee::RecordDepartureService # rubocop:disable Style/Documentation, Style/ClassAndModuleChildren
  def self.call(employee_id, departure_date) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    employee_id = Integer(employee_id)
    departure_date = normalize_departure_date(departure_date)

    ActiveRecord::Base.transaction do
      employee = Employee.unscoped.lock.find_by!(employee_id: employee_id)
      raise ArgumentError, 'Employee is no longer employed.' unless employee.still_employed?
      if departure_date < employee.employment_date
        raise ArgumentError, 'Departure date cannot be before the employment date.'
      end
      raise ArgumentError, 'Departure date cannot be in the future.' if departure_date > Date.current

      now = Time.current
      employee.update!(still_employed: false, departure_date: departure_date)
      close_active_associations!(employee_id, departure_date, now)
      deactivate_user!(employee_id, now)
    end
  end

  def self.normalize_departure_date(value)
    raise ArgumentError, 'Departure date is required.' if value.blank?

    value.is_a?(Date) ? value : Date.iso8601(value.to_s)
  rescue Date::Error
    raise ArgumentError, 'Departure date must be a valid date.'
  end
  private_class_method :normalize_departure_date

  def self.close_active_associations!(employee_id, departure_date, now)
    Affiliation.where(employee_id: employee_id, is_terminated: false)
               .update_all(is_terminated: true, ended_on: departure_date, updated_at: now)
    EmployeeDesignation.unscoped.where(employee_id: employee_id, end_date: nil)
                       .update_all(end_date: departure_date, updated_at: now)
    ProjectTeam.where(employee_id: employee_id, voided: false, end_date: nil)
               .update_all(end_date: departure_date, updated_at: now)
    Supervision.unscoped.where(is_terminated: false)
               .where('supervisor = :employee_id OR supervisee = :employee_id', employee_id: employee_id)
               .update_all(is_terminated: true, ended_on: departure_date, updated_at: now)
  end
  private_class_method :close_active_associations!

  def self.deactivate_user!(employee_id, now)
    User.where(employee_id: employee_id)
        .update_all(activated: false, deactivated_at: now, updated_at: now)
  end
  private_class_method :deactivate_user!
end

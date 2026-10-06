# frozen_string_literal: true

class Employee::VoidEmployeeService # rubocop:disable Style/Documentation, Style/ClassAndModuleChildren
  def self.call(employee_id) # rubocop:disable Metrics/MethodLength
    employee_id = Integer(employee_id)

    ActiveRecord::Base.transaction do
      employee = Employee.unscoped.lock.find_by!(employee_id: employee_id)
      raise ArgumentError, 'Employee is no longer employed.' unless employee.still_employed?

      now = Time.current
      effective_date = Date.current
      employee.update!(still_employed: false)
      Person.where(person_id: employee.person_id).update_all(voided: true, updated_at: now)
      close_active_associations!(employee_id, effective_date, now)
      User.where(employee_id: employee_id)
          .update_all(activated: false, deactivated_at: now, updated_at: now)
    end
  end

  def self.close_active_associations!(employee_id, effective_date, now)
    Affiliation.where(employee_id: employee_id, is_terminated: false)
               .update_all(is_terminated: true, ended_on: effective_date, updated_at: now)
    EmployeeDesignation.unscoped.where(employee_id: employee_id, end_date: nil)
                       .update_all(end_date: effective_date, updated_at: now)
    ProjectTeam.where(employee_id: employee_id, voided: false, end_date: nil)
               .update_all(voided: true, end_date: effective_date, updated_at: now)
    Supervision.unscoped.where(is_terminated: false)
               .where('supervisor = :employee_id OR supervisee = :employee_id', employee_id: employee_id)
               .update_all(is_terminated: true, ended_on: effective_date, updated_at: now)
  end
  private_class_method :close_active_associations!
end

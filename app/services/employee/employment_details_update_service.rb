# frozen_string_literal: true

class Employee::EmploymentDetailsUpdateService
  def self.call(employee, attributes)
    ActiveRecord::Base.transaction do
      employment_date = attributes.fetch(:employment_date)
      department = Department.find_by!(
        department_name: attributes.fetch(:departments),
        branch_id: attributes.fetch(:branch)
      )

      validate_branch!(department, attributes[:branch])
      current_affiliation = employee.current_affiliations.first
      employee.update!(employment_date: employment_date, departure_date: attributes[:departure_date])
      update_affiliation!(employee, department, employment_date)
      update_designation!(
        employee,
        department,
        attributes.fetch(:designated_role),
        attributes.fetch(:designation_start_date),
        preserve_current_designation: current_affiliation&.department_id == department.id
      )
    end
  end

  def self.validate_branch!(department, branch_id)
    return if branch_id.blank? || department.branch_id == branch_id.to_i

    raise ArgumentError, 'Selected department does not belong to the selected branch.'
  end
  private_class_method :validate_branch!

  def self.update_affiliation!(employee, department, started_on)
    affiliation = employee.current_affiliations.first_or_initialize
    affiliation.update!(department: department, started_on: started_on, is_terminated: false)
  end
  private_class_method :update_affiliation!

  def self.update_designation!(employee, department, role, start_date, preserve_current_designation:)
    employee_designation = employee.current_designations.first
    designation = Designation.find_by(department: department, designated_role: role)

    if designation.nil? && preserve_current_designation &&
       employee_designation&.designation&.designated_role == role
      designation = employee_designation.designation
    end

    unless designation
      raise ArgumentError, "The role '#{role}' is not available in the selected department."
    end

    employee_designation ||= employee.current_designations.build
    employee_designation.update!(designation: designation, start_date: start_date)
  end
  private_class_method :update_designation!
end

# frozen_string_literal: true

class Employee::EmploymentDetailsUpdateService
  def self.call(employee, attributes)
    ActiveRecord::Base.transaction do
      employment_date = attributes.fetch(:employment_date)
      department = Department.find_by!(department_name: attributes.fetch(:departments))

      validate_branch!(department, attributes[:branch])
      employee.update!(employment_date: employment_date)
      update_affiliation!(employee, department, employment_date)
      update_designation!(
        employee,
        department,
        attributes.fetch(:designated_role),
        attributes.fetch(:designation_start_date)
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

  def self.update_designation!(employee, department, role, start_date)
    designation = Designation.find_by!(department: department, designated_role: role)
    employee.current_designations.first_or_initialize.update!(designation: designation, start_date: start_date)
  end
  private_class_method :update_designation!
end

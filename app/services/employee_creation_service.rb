# frozen_string_literal: true

require 'securerandom'

class EmployeeCreationService # rubocop:disable Style/Documentation
  def self.call(data, session) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    ActiveRecord::Base.transaction do # rubocop:disable Metrics/BlockLength
      person = Person.create!(data[:person])

      employee = Employee.create!(
        person_id: person.id,
        employment_date: data[:employee][:employment_date],
        still_employed: true
      )

      password = SecureRandom.alphanumeric
      username = generate_username(person)
      User.create!(
        employee_id: employee.id,
        username: username, # rubocop:disable Style/HashSyntax
        password: password, # rubocop:disable Style/HashSyntax
        activated_at: Time.current,
        activated: true
      )

      Affiliation.create!(
        employee_id: employee.id,
        department_id: Department.find_by_department_name(data[:employee][:departments]).department_id,
        started_on: data[:employee][:employment_date],
        is_terminated: false,
        created_at: Time.current
      )

      EmployeeDesignation.create!(
        employee_id: employee.id,
        designation_id: Designation.find_by_designated_role(
          data[:employee][:designated_role]
        ).designation_id,
        start_date: data[:employee][:designation_start_date]
      )

      data[:project].each do |project|
        ProjectTeam.create!(
          project_id: get_project_id(project[:project]),
          employee_id: employee.id,
          allocated_effort: project[:allocated_effort],
          start_date: data[:employee][:employment_date]
        )
      end

      Supervision.create!(
        supervisor: data[:supervision][:supervisor],
        supervisee: employee.id,
        started_on: data[:supervision][:started_on]
      )

      session[:last_username] = username
      session[:last_password] = password

      employee
    end
  end

  # HELPERS
  def self.generate_username(person)
    "#{person.last_name}#{SecureRandom.alphanumeric(3)}"
  end

  def self.get_designation_id(data)
    department_id = Department.where(department_name: data[:employee][:departments]).pluck(:department_id)
    Designation.where(designated_role: data[:employee][:designated_role], department_id: department_id) # rubocop:disable Style/HashSyntax
  end

  def self.get_project_id(project_name)
    Project.where(short_name: project_name).pluck(:project_id).first
  end
end

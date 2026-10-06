# frozen_string_literal: true

class Employee::PersonalDemographicsUpdateService
  def self.call(employee, attributes)
    employee.person.update!(attributes)
  end
end

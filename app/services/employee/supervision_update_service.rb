# frozen_string_literal: true

class Employee::SupervisionUpdateService
  def self.call(employee, attributes)
    ActiveRecord::Base.transaction do
      supervisor = Employee.find(attributes.fetch(:supervisor))
      raise ArgumentError, 'An employee cannot supervise themselves.' if supervisor == employee

      supervision = employee.received_supervision || Supervision.new(supervisee: employee.id)
      supervision.update!(supervisor: supervisor.id, started_on: attributes.fetch(:started_on), is_terminated: false)
    end
  end
end

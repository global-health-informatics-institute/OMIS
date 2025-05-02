class Supervision < ApplicationRecord
  self.primary_key = 'supervision_id'

  belongs_to :supervisor_employee, foreign_key: 'supervisor', class_name: 'Employee'
  belongs_to :supervisee_employee, foreign_key: 'supervisee', class_name: 'Employee'
end

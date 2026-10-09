class Person < ApplicationRecord
  has_one :employee, :foreign_key => :employee_id
  default_scope { joins(:employee).where('employees.still_employed = ? OR employees.still_employed IS NULL', true) }

  def full_name
    return (self.first_name || '') + " " + (self.middle_name || '') + " " + (self.last_name || '').squish
  end
end

class Person < ApplicationRecord
  has_one :employee, :foreign_key => :employee_id

  def full_name
    return (self.first_name || '') + " " + (self.middle_name || '') + " " + (self.last_name || '').squish
  end
end

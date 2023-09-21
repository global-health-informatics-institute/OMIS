class EmployeeDesignation < ApplicationRecord
  belongs_to :employee
  belongs_to :designation

  def pretty_display
    return { designation_id: self .designation_id, start_date: self.start_date,
             end_date: self .end_date, title: self.designation.designated_role}
  end
end

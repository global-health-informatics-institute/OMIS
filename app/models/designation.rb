class Designation < ApplicationRecord
  belongs_to :department, :foreign_key => :department_id

  def branch
    self.department.branch
  end

  def department_name
    self.department.department_name
  end

end

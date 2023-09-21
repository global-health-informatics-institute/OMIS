class Affiliation < ApplicationRecord
  belongs_to :employee, foreign_key: :employee_id
  belongs_to :department, foreign_key: :department_id

  def pretty_display
    conn_dept = self.department
    conn_branch = conn_dept.branch
    return { affliation_id: self.affliation_id, department_id: self.department_id,
             branch_id: conn_branch.branch_id, department_name: self.department.department_name,
             branch_name: conn_branch.branch_name, branch_country: conn_branch.country,
             branch_city: conn_branch.city, branch_location: conn_branch.location,
             started_on: self .started_on, ended_on: self.ended_on, is_terminated: self.is_terminated
    }
  end
end

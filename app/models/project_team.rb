class ProjectTeam < ApplicationRecord
  has_one :project, foreign_key: :project_id
  has_one :employee, foreign_key: :employee_id
end

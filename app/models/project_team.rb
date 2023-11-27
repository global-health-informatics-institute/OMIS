class ProjectTeam < ApplicationRecord
  belongs_to :project, foreign_key: :project_id
  belongs_to :employee, foreign_key: :employee_id
end

class Project < ApplicationRecord
  belongs_to :employee, :foreign_key => :manager
  has_many :project_tasks

  has_many :donor_projects
  has_many :donors, through: :donor_projects

  def upcoming_deadlines
    return ProjectTask.where("deadline >= ?", Date.today)
  end

end

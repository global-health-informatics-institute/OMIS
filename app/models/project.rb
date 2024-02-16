class Project < ApplicationRecord
  belongs_to :employee, :foreign_key => :manager
  has_many :project_tasks

  def upcoming_deadlines
    return ProjectTask.where("deadline >= ?", Date.today)
  end

end

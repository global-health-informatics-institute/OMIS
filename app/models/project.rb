class Project < ApplicationRecord
  belongs_to :employee, :foreign_key => :manager
end

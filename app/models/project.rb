class Project < ApplicationRecord
  belongs_to :person, :foreign_key => :manager
end

class Department < ApplicationRecord
    belongs_to :branch, :foreign_key => :branch_id
    has_many :affliations , :foreign_key => :department_id
    has_many :employees, through: :affliations
end

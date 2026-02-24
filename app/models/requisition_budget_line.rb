class RequisitionBudgetLine < ApplicationRecord
  belongs_to :requisition
  belongs_to :budget_line
end

# frozen_string_literal: true

# Model representing the association between a Requisition and a BudgetLine.
class RequisitionBudgetLine < ApplicationRecord
  belongs_to :requisition, foreign_key: 'requisition_id', optional: false
  belongs_to :budget_line

  scope :active, -> { where(voided: false) }
end

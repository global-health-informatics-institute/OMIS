# frozen_string_literal: true

# Model representing the association between a RequisitionItem and a BudgetLine.
class RequisitionBudgetLine < ApplicationRecord
  belongs_to :requisition_item, foreign_key: 'requisition_item_id', optional: true
  belongs_to :budget_line

  scope :active, -> { where(voided: false) }
end

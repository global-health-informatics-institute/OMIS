# frozen_string_literal: true

class BudgetLine < ApplicationRecord # rubocop:disable Style/Documentation
  has_many :requisition_budget_lines
  has_many :requisitions, through: :requisition_budget_lines
end

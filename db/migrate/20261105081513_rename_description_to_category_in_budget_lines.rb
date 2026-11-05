# frozen_string_literal: true

# migration to rename description column to category in budget_lines table
class RenameDescriptionToCategoryInBudgetLines < ActiveRecord::Migration[7.0]
  def change
    rename_column :budget_lines, :description, :category
  end
end

# frozen_string_literal: true

class UpdateBudgetLinesStructure < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    rename_column :budget_lines, :budget_line, :budget_line_ref
    add_column :budget_lines, :description, :text
  end
end

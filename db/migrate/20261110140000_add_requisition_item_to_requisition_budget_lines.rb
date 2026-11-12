# frozen_string_literal: true

class AddRequisitionItemToRequisitionBudgetLines < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    add_reference :requisition_budget_lines, :requisition_item,
                  null: true,
                  foreign_key: { to_table: :requisition_items, primary_key: :requisition_item_id }
  end
end

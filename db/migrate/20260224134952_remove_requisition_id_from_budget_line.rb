class RemoveRequisitionIdFromBudgetLine < ActiveRecord::Migration[7.0]
  def change
    remove_column :budget_lines, :requisition_id, :integer
  end
end

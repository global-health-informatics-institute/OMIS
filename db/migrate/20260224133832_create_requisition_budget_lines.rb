class CreateRequisitionBudgetLines < ActiveRecord::Migration[7.0]
  def change
    create_table :requisition_budget_lines do |t|
      t.integer :requisition_id, null: false
      t.foreign_key :requisitions, column: :requisition_id, primary_key: :requisition_id
      t.references :budget_line, null: false, foreign_key: true
      t.boolean :voided

      t.timestamps
    end
  end
end

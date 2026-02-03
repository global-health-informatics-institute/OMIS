class CreateBudgetLines < ActiveRecord::Migration[7.0]
  def change
    create_table :budget_lines do |t|
      t.integer :requisition_id, null: false
      t.foreign_key :requisitions, column: :requisition_id, primary_key: :requisition_id

      t.string :budget_line, null: false
      t.boolean :voided, default: false, null: false

      t.timestamps
    end
  end
end

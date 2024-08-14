class CreateInventoryItemIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_item_issues do |t|
      t.integer :requisition_id, null: false
      t.integer :inventory_item_id, null: false
      t.decimal :quantity_issued, null: false, default: 0.0
      t.date :issue_date, null: false
      t.integer :issued_by, null: false
      t.integer :issued_to, null: false
      t.timestamps
    end
  end
end

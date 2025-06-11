class AddRequisitionToPettyCashComment < ActiveRecord::Migration[7.0]
  def change
    create_table :petty_cash_comments do |t|
      t.text :comment
      t.decimal :used_amount, precision: 10, scale: 2
      t.bigint :requisition_id, null: false
      t.timestamps
    end

    # Add a foreign key to requisitions(requisition_id)
    add_foreign_key :petty_cash_comments, :requisitions, column: :requisition_id, primary_key: :requisition_id
  end
end

class CreateRequisitionNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :requisition_notes do |t|
      t.integer :requisition_id, null: false
      t.integer :user_id, null: false
      t.text :note
      t.boolean :voided, default: false
      t.timestamps
    end
  end
end

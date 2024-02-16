class CreateRequisitions < ActiveRecord::Migration[7.0]
  def change
    create_table :requisitions, :primary_key => 'requisition_id' do |t|
      t.string :purpose, null: false
      t.integer :initiated_by, null: false
      t.datetime :initiated_on, null: false
      t.string :requisition_type, null: false
      t.integer :reviewed_by
      t.integer :approved_by
      t.integer :workflow_state_id, null: false
      t.boolean :voided, null: false, default: false
      t.timestamps
    end
  end
end

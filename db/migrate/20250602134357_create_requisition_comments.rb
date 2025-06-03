class CreateRequisitionComments < ActiveRecord::Migration[7.0]
  def change
    create_table :requisition_comments do |t|
      t.references :requisition, null: false, foreign_key: { to_table: :requisitions, primary_key: :requisition_id }
      t.text :description
      # 'workflow_state_id' is the primary key in your 'workflow_states' table
      t.references :workflow_state, null: false, foreign_key: { to_table: :workflow_states, primary_key: :workflow_state_id }
      t.boolean :voided, default: false

      t.timestamps
    end
  end
end

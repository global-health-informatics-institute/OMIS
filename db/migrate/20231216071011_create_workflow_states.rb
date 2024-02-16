class CreateWorkflowStates < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_states, :primary_key => 'workflow_state_id'  do |t|
      t.integer :workflow_process_id
      t.string :state, null: false
      t.string :description
      t.boolean :voided, default: false
      t.timestamps
    end
  end
end

class CreateWorkflowStateTransitions < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_state_transitions do |t|
      t.integer :workflow_state_id, null: false
      t.integer :next_state, null: false
      t.boolean :voided, default: false
      t.timestamps
    end
  end
end

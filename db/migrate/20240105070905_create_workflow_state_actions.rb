class CreateWorkflowStateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_state_actions do |t|
      t.integer :workflow_state_id, null: false
      t.string :state_action, null: false
      t.timestamps
    end
  end
end

class CreateDesignationWorkflowStateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :designation_workflow_state_actions do |t|
      t.integer :workflow_state_id, null: false
      t.integer :designation_id, null: false
      t.boolean :voided , default: false
      t.timestamps
    end
  end
end

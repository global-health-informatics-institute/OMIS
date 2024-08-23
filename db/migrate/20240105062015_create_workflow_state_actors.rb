class CreateWorkflowStateActors < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_state_actors do |t|
      t.integer :workflow_state_transition_id
      t.integer :employee_designation_id, null: false
      t.boolean :voided, default: false
      t.timestamps
    end
  end
end

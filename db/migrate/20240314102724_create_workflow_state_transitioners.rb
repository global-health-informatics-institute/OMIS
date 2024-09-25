class CreateWorkflowStateTransitioners < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_state_transitioners do |t|
      t.integer :workflow_state_transition
      t.integer :stakeholder
      t.date :start_date
      t.date :end_date
      t.boolean :voided
      t.timestamps
    end
  end
end

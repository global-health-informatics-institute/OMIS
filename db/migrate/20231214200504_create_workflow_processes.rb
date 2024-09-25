class CreateWorkflowProcesses < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_processes, :primary_key => 'workflow_process_id'  do |t|
      t.string :workflow, null: false
      t.boolean :active, default: true
      t.integer :start_state
      t.timestamps
    end
  end
end

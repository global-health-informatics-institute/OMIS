class CreateWorkflowProcesses < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_processes, :primary_key => 'workflow_process_id'  do |t|
      t.string :workflow, null: false
      t.timestamps
      t.boolean :active, default: true
    end
  end
end

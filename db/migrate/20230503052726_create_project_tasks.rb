class CreateProjectTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :project_tasks, :primary_key => 'project_task_id' do |t|
      
      t.integer :project_id, null: false
      t.string :task_description, null: false
      t.decimal :estimated_duration
      t.datetime :deadline
      t.string :task_status #(Unassigned,Assigned, in progress, Overdue, Completed),
      t.integer :performed_by 
      t.boolean :voided, default: false      
      t.timestamps
    end
  end
end

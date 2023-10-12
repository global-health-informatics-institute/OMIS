class CreateProjectTaskAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :project_task_assignments, :primary_key => 'project_task_assignment_id' do |t|
      t.integer :project_task_id, null: false
      t.integer :assigned_to, null: false
      t.boolean :revoked, default: false, null: false
      t.timestamps
    end
  end
end

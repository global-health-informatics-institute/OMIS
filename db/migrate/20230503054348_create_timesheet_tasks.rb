class CreateTimesheetTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :timesheet_tasks do |t|
      t.integer :timesheet_id, null: false
      t.integer :project_id, null: false
      t.date :task_date, null: false
      t.string :description
      t.decimal :duration
      t.timestamps
    end
  end
end

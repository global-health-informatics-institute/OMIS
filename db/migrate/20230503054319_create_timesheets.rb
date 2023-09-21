class CreateTimesheets < ActiveRecord::Migration[7.0]
  def change
    create_table :timesheets, :primary_key => 'timesheet_id' do |t|
      t.integer :employee_id, null: false
      t.date :timesheet_week, null: false
      t.datetime :submitted_on
      t.integer :approved_by
      t.datetime :approved_on 
      t.timestamps
    end
  end
end

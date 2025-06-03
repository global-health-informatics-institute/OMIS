class AddTimesheetIdToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :timesheet_id, :integer
  end
end

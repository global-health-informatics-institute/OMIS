class AddStateToTimesheet < ActiveRecord::Migration[7.0]
  def change
    add_column :timesheets, :state, :integer
  end
end

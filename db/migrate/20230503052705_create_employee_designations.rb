class CreateEmployeeDesignations < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_designations, :primary_key => 'employee_designation_id' do |t|
      t.integer :employee_id, null: false
      t.integer :designation_id, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.timestamps
    end
  end
end

class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees, :primary_key => 'employee_id' do |t|
      t.integer :person_id, null: false
      t.date :employment_date, null: false
      t.boolean :still_employed, null: false, default: true
      t.date :departure_date, 
      t.timestamps
    end
  end
end

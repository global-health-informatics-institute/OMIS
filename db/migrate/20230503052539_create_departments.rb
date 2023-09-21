class CreateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :departments, :primary_key => 'department_id' do |t|
      t.integer :branch_id, null: false
      t.string :department_name, null: false
      t.boolean :is_active, default: true
      t.integer :created_by
      t.timestamps
    end
  end
end

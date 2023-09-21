class CreateDesignations < ActiveRecord::Migration[7.0]
  def change
    create_table :designations, :primary_key => 'designation_id' do |t|
      t.integer :department_id, null: false
      t.string :designated_role, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end

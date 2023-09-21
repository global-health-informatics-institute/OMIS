class CreateAffiliations < ActiveRecord::Migration[7.0]
  def change
    create_table :affiliations, :primary_key => 'affliation_id' do |t|
      t.integer :employee_id, null: false
      t.integer :department_id, null: false
      t.date :started_on, null: false
      t.date :ended_on
      t.boolean :is_terminated, null: false, default: false
      t.timestamps
    end
  end
end

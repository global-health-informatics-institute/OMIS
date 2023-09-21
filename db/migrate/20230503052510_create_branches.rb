class CreateBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :branches, :primary_key => 'branch_id' do |t|
      t.string :branch_name, null: false
      t.string :country, null: false
      t.string :city, null: false
      t.string :location, null: false
      t.integer :created_by
      t.integer :closed_by
      t.boolean :is_open, default: true
      t.timestamps
    end
  end
end

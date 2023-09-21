class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects, :primary_key => 'project_id' do |t|
      
      t.string :project_name, null: false
      t.string :short_name
      t.string :project_description, null: false
      t.integer :manager, null: false
      t.integer :created_by
      t.integer :closed_by
      t.boolean :is_active, null: false, default: true
      t.datetime :completed_at
      t.timestamps
    end
  end
end

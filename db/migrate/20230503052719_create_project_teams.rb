class CreateProjectTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :project_teams, :primary_key => 'project_team_id' do |t|
      t.integer :project_id, null: false
      t.integer :employee_id, null: false
      t.float :allocated_effort, default: 0.0
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :voided, null: false, default: false      
      t.timestamps
    end
  end
end

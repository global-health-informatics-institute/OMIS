# frozen_string_literal: true

# CreateDonorProjects migration to link donors and projects
class CreateDonorProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :donor_projects do |t|
      t.references :donor, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: { to_table: :projects, primary_key: :project_id }
      t.boolean :voided, default: false, null: false

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateCommitteesAndMemberships < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change # rubocop:disable Metrics/MethodLength
    create_table :committees, primary_key: :committee_id do |t|
      t.string :name, null: false
      t.string :short_name, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :committee_memberships, primary_key: :committee_membership_id do |t|
      t.integer :employee_id, null: false
      t.integer :committee_id, null: false
      t.string :role, null: false
      t.date :started_on, null: false
      t.date :ended_on

      t.timestamps
    end

    add_foreign_key :committee_memberships, :committees, column: :committee_id, primary_key: :committee_id
    add_foreign_key :committee_memberships, :employees, column: :employee_id, primary_key: :employee_id
  end
end

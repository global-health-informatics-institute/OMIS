# frozen_string_literal: true

class CreateCommitteeMeetings < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change # rubocop:disable Metrics/MethodLength
    create_table :committee_meetings, primary_key: :committee_meeting_id do |t|
      t.integer :requisition_id, null: false
      t.integer :committee_id, null: false
      t.date :scheduled_on, null: false
      t.integer :scheduled_by, null: false
      t.string :status, null: false, default: 'Scheduled'

      t.timestamps
    end

    add_index :committee_meetings, %i[requisition_id status]
    add_foreign_key :committee_meetings, :requisitions, column: :requisition_id, primary_key: :requisition_id
    add_foreign_key :committee_meetings, :committees, column: :committee_id, primary_key: :committee_id
    add_foreign_key :committee_meetings, :employees, column: :scheduled_by, primary_key: :employee_id
  end
end

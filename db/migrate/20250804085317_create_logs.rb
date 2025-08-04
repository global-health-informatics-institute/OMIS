# frozen_string_literal: true

class CreateLogs < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change # rubocop:disable Metrics/MethodLength
    create_table :logs do |t|
      t.references :loggable, polymorphic: true, null: false
      t.integer :prev_state
      t.integer :next_state
      t.integer :transition
      t.integer :transition_by
      t.text :description
      t.timestamps
    end
    # add_index :logs, [:loggable_type, :loggable_id], name: 'index_logs_on_loggable'
    add_index :logs, :transition, name: 'index_logs_on_transition'
    add_index :logs, :transition_by, name: 'index_logs_on_transition_by'
  end
end

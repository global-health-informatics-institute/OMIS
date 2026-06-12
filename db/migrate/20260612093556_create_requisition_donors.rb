# frozen_string_literal: true

class CreateRequisitionDonors < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    create_table :requisition_donors do |t|
      t.references :requisition, null: false, foreign_key: { primary_key: :requisition_id }
      t.references :donor, null: false, foreign_key: true

      t.boolean :voided, default: false, null: false
      t.timestamps
    end
  end
end

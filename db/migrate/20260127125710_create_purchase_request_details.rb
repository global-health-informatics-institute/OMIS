# frozen_string_literal: true

# migration file to create purchase_request_details table
class CreatePurchaseRequestDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_request_details do |t|
      t.integer :requisition_id, null: false
      t.foreign_key :requisitions, column: :requisition_id, primary_key: :requisition_id

      t.string :vendor_name
      t.integer :donor_id
      t.integer :department_id
      t.boolean :voided, default: false, null: false

      t.timestamps
    end
  end
end

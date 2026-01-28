# frozen_string_literal: true

# migration file to create donors table
class CreateDonors < ActiveRecord::Migration[7.0]
  def change
    create_table :donors do |t|
      t.integer :donor_id
      t.string :name
      t.string :short_name
      t.text :description
      t.boolean :voided, default: false, null: false

      t.timestamps
    end
  end
end

# frozen_string_literal: true

# Migration to add item_name column to purchase_request_details table
class AddItemNameToPurchaseRequestDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :purchase_request_details, :item_name, :string
  end
end

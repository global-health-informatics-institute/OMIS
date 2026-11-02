# frozen_string_literal: true

class AddQuotationTaxFlagsToPurchaseRequestDetails < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    add_column :purchase_request_details, :unit_price, :decimal, precision: 12, scale: 2
    add_column :purchase_request_details, :attracts_levy, :boolean
    add_column :purchase_request_details, :attracts_mra, :boolean
  end
end

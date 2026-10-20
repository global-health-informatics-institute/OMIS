# frozen_string_literal: true

class AddVendorContactDetailsToPurchaseRequestDetails < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    add_column :purchase_request_details, :vendor_mobile_number, :string
    add_column :purchase_request_details, :vendor_email, :string
  end
end

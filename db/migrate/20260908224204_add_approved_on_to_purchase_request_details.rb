# frozen_string_literal: true

class AddApprovedOnToPurchaseRequestDetails < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    add_column :purchase_request_details, :approved_on, :datetime
  end
end

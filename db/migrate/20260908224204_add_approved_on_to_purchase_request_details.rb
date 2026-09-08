class AddApprovedOnToPurchaseRequestDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :purchase_request_details, :approved_on, :datetime
  end
end

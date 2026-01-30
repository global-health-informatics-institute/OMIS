class AddItemQuantityToPurchaseRequestDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :purchase_request_details, :item_quantity, :integer
  end
end

class AddItemRequestedToPurchaseRequestAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :purchase_request_attachments, :item_requested, :string
  end
end

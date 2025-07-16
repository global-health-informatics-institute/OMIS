class AddRequiresIpcToPurchaseRequestAttachments < ActiveRecord::Migration[7.0]
  def change
  add_column :purchase_request_attachments, :requires_ipc, :boolean, default: false
  end
end

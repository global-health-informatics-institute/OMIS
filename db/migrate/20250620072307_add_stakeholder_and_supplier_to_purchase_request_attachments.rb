class AddStakeholderAndSupplierToPurchaseRequestAttachments < ActiveRecord::Migration[6.1]  # or your version
  def change
    add_column :purchase_request_attachments, :stakeholder_id, :integer
    add_column :purchase_request_attachments, :supplier, :string

    # Optional: Add a foreign key constraint if stakeholders table exists
    add_foreign_key :purchase_request_attachments, :stakeholders, column: :stakeholder_id, primary_key: :stakeholder_id
    add_index :purchase_request_attachments, :stakeholder_id
  end
end

class CreatePurchaseRequestAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_request_attachments, id: :bigint do |t|
      t.bigint :requisition_id, null: false
      t.boolean :voided
      t.text :comments

      t.timestamps
    end

    # Move this outside of the `create_table` block!
    add_foreign_key :purchase_request_attachments, :requisitions, column: :requisition_id, primary_key: :requisition_id
  end
end

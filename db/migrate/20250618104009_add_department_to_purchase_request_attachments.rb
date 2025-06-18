class AddDepartmentToPurchaseRequestAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :purchase_request_attachments, :department_id, :integer
    add_foreign_key :purchase_request_attachments, :departments, column: :department_id, primary_key: :department_id

  end
end

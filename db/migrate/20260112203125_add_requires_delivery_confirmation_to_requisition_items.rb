class AddRequiresDeliveryConfirmationToRequisitionItems < ActiveRecord::Migration[7.0]
  def change
    add_column :requisition_items, :requires_delivery_confirmation, :boolean, default: false
  end
end

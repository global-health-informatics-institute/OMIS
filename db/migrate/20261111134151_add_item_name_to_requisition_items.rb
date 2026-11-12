class AddItemNameToRequisitionItems < ActiveRecord::Migration[7.0]
  def change
    add_column :requisition_items, :item_name, :string, null: true
  end
end

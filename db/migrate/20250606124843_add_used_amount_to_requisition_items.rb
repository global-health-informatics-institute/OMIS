class AddUsedAmountToRequisitionItems < ActiveRecord::Migration[7.0]
  def change
    add_column :requisition_items, :used_amount, :decimal, precision: 10, scale: 2
  end
end

class AddRequisitionToAssets < ActiveRecord::Migration[6.1]
  def change
    add_column :assets, :requisition_id, :integer
    add_index :assets, :requisition_id
    add_foreign_key :assets, :requisitions, column: :requisition_id, primary_key: :requisition_id
  end
end

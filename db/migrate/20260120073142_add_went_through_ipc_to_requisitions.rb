class AddWentThroughIpcToRequisitions < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :went_through_ipc, :boolean, default: false
  end
end

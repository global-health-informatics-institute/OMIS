class RemoveCollectedFromRequisition < ActiveRecord::Migration[7.0]
  def change
    remove_column :requisitions, :collected, :boolean
  end
end

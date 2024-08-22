class AddCollectedToRequisition < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :collected, :boolean, default: false
  end
end

class AddAmountToRequisition < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :amount, :float
  end
end

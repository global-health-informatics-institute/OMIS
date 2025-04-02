class AddPettyCashLimitToRequisitions < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :petty_cash_limit, :decimal
  end
end

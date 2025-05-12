class AddDenyFundsTokenToRequisitions < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :deny_funds_token, :string
    add_index :requisitions, :deny_funds_token, unique: true
  end
end

class AddApprovalFundsTokenToRequisitions < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :approval_funds_token, :string
    add_index :requisitions, :approval_funds_token, unique: true
  end
end

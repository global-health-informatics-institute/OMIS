class AddApprovalTokenToRequisitions < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :approval_token, :string
    add_index :requisitions, :approval_token, unique: true

  end
end

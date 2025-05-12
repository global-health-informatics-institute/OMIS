class AddRejectionTokenToRequisitions < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :rejection_token, :string
    add_index :requisitions, :rejection_token, unique: true
  end
end

class AddStatusToRequisitions < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :status, :string
  end
end

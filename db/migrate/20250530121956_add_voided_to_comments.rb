class AddVoidedToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :voided, :false 
  end
end

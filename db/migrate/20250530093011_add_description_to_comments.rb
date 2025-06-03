class AddDescriptionToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :description, :text
  end
end

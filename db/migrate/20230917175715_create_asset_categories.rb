class CreateAssetCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :asset_categories do |t|
      t.string :category, null: false
      t.text :description
      t.boolean :voided, default: false
      t.timestamps
    end
  end
end

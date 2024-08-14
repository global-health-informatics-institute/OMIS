class CreateInventoryItemCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_item_categories, :primary_key => 'inventory_item_category_id' do |t|
      t.string :category, null: false #Electronic components, stationary, Drinks, Cleaning Supplies,Health Care, Toiletries, Condiments
      t.boolean :voided, null: false, default: false
      t.integer :created_by, null: false
      t.timestamps
    end
  end
end

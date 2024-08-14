class CreateInventoryItemTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_item_types, :primary_key => 'inventory_item_type_id' do |t|
      t.integer :inventory_item_category_id, null: false
      t.string :item_name, null: false
      t.string :manufacturer, null: false
      t.integer :created_by, null: false
      t.timestamps
    end
  end
end

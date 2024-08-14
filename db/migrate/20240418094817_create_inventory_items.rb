class CreateInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_items, :primary_key => 'inventory_item_id' do |t|
      t.integer :item_type_id, null: false
      t.integer :quantity, null: false, default: 0
      t.integer :quantity_used, null: false, default: 0
      t.string :supplier, null: false
      t.decimal :unit_price, precision: 10, scale: 2
      t.string :storage_location
      t.integer :created_by, null: false
      t.integer :voided_by
      t.boolean :voided, null: false, default: false
      t.timestamps
    end
  end
end


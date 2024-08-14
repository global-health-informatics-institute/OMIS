class CreateInventoryItemThresholds < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_item_thresholds, :primary_key => 'inventory_item_threshold_id' do |t|
      t.integer :inventory_item_id, null: false
      t.decimal :minimum_quantity, null: true, default: 0
      t.decimal :maximum_quantity, null: true, default: 0
      t.boolean :voided, null: false, default: false
      t.timestamps
    end
  end
end

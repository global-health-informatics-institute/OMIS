class CreateRequisitionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :requisition_items, :primary_key => 'requisition_item_id' do |t|
      t.integer :requisition_id, null: false
      t.decimal :quantity
      t.string :item_description
      t.timestamps
    end
  end
end

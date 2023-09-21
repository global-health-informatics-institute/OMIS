class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets, :primary_key => 'asset_id' do |t|
      t.integer :asset_category_id, null: false
      t.string :tag_id, null: false
      t.string :description, null: false
      t.string :make
      t.string :model
      t.string :serial_number
      t.string :location, null: false
      t.float :value, null: false
      t.string :status, null: false
      t.string :disposal_reason
      t.timestamps
    end
  end
end

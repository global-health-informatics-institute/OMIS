class CreateGlobalProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :global_properties, :primary_key => 'property_id' do |t|
      t.string :property
      t.string :property_value
      t.string :description
      t.timestamps
    end
  end
end

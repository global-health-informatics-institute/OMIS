class AddAssetIdToTravelRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :travel_requests, :asset_id, :integer
    add_foreign_key :travel_requests, :assets, column: :asset_id, primary_key: :asset_id
    add_index :travel_requests, :asset_id
  end
end

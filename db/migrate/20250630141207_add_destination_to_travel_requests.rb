class AddDestinationToTravelRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :travel_requests, :destination, :string
  end
end

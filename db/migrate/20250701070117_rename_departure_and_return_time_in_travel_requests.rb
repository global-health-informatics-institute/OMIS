class RenameDepartureAndReturnTimeInTravelRequests < ActiveRecord::Migration[6.1] # or your version
  def change
    rename_column :travel_requests, :departure_time, :departure_date
    rename_column :travel_requests, :return_time, :return_date
  end
end

class CreateTravelRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :travel_requests do |t|
      t.bigint :requisition_id, null: false
      t.foreign_key :requisitions, column: :requisition_id, primary_key: :requisition_id

      t.integer :distance
      t.boolean :voided, default: false
      t.text :traveler_names
      t.datetime :departure_date
      t.datetime :return_date

      t.timestamps
    end
  end
end

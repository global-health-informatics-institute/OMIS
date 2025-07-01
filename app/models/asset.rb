# app/models/asset.rb
class Asset < ApplicationRecord
  has_many :travel_requests # Existing association
  belongs_to :asset_category # Ensure this association also exists

  # THIS SCOPE IS MISSING OR INCORRECTLY DEFINED IN YOUR FILE
  scope :vehicles, -> {
    # First, find the AssetCategory record whose category is 'Vehicles'
    vehicle_category = AssetCategory.find_by(category: 'Vehicles')

    if vehicle_category.present?
      # join with asset_categories table and filter assets by that category's ID.
      joins(:asset_category).where(asset_categories: { id: vehicle_category.id })
    else
      # to prevent errors, and the dropdown will simply be empty.
      none
    end
  }
end
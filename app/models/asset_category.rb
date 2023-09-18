class AssetCategory < ApplicationRecord
  validates_presence_of :category, :description
  validates_uniqueness_of :category
end

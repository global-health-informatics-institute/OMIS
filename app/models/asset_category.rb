class AssetCategory < ApplicationRecord
  validates_presence_of :category, :description
  validates_uniqueness_of :category
  has_many :assets 
  validates :category, presence: true, uniqueness: true
end

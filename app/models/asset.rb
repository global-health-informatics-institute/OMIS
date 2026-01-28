class Asset < ApplicationRecord
  belongs_to :requisition, primary_key: :requisition_id, foreign_key: :requisition_id
  
  # Validations
  validates :asset_category_id, presence: true
  validates :description, presence: true
  validates :make, presence: true
  validates :model, presence: true
  validates :serial_number, presence: true
  validates :location, presence: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :tag_id, presence: true
  validates :status, presence: true
end

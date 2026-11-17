# frozen_string_literal: true


# A tax or fee that can be applied to a requisition item
class Charge < ApplicationRecord
  VALUE_TYPES = %w[rate fee].freeze

  belongs_to :global_property, primary_key: :property_id
  has_many :requisition_item_charges, dependent: :restrict_with_error
  has_many :requisition_items, through: :requisition_item_charges

  attr_readonly :value_type # a charge never switches between a rate and a fee

  validates :name, presence: true, uniqueness: true
  validates :value_type, inclusion: { in: VALUE_TYPES }

  scope :active, -> { where(voided: false) }
  scope :for_items, -> { active.where(applies_to_item: true) }
  scope :for_suppliers, -> { active.where(applies_to_supplier: true) }

  def rate? = value_type == 'rate'
  def fee? = value_type == 'fee'

  # current value as a number, read from the global property
  def value
    BigDecimal(global_property.property_value)
  end
end
# frozen_string_literal: true

# A tax or fee that can be applied to a requisition item
class Charge < ApplicationRecord
  VALUE_TYPES = %w[rate fee].freeze

  belongs_to :global_property, primary_key: :property_id
  has_many :requisition_item_charges, dependent: :restrict_with_error

  attr_readonly :value_type # a charge never switches between a rate and a fee

  validates :value_type, inclusion: { in: VALUE_TYPES }

  default_scope { where(voided: false) }

  def rate? = value_type == 'rate'
  def fee? = value_type == 'fee'

  # current value as a number, read from the global property
  def value
    BigDecimal(global_property.property_value)
  end
end
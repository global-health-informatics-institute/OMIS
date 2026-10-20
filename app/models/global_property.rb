class GlobalProperty < ApplicationRecord
  def self.petty_cash_limit
    Rails.cache.fetch('global_properties/petty_cash_limit', expires_in: 1.hour) do
      # Use correct column name 'property_value' and add error handling
      record = find_by(property: 'petty.cash.limit')
      record ? record.property_value.to_f : 40_000
    end
  end

  def self.levy_rate
    quotation_rate('Levy rate')
  end

  def self.mra_rate
    quotation_rate('MRA rate')
  end

  def self.quotation_rate(property)
    property_value = find_by(property: property)&.property_value
    return 0.to_d if property_value.blank?

    rate = property_value.to_d
    rate > 1 ? rate / 100 : rate
  end
  private_class_method :quotation_rate
end

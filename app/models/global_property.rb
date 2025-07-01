class GlobalProperty < ApplicationRecord
  def self.petty_cash_limit
    Rails.cache.fetch('global_properties/petty_cash_limit', expires_in: 1.hour) do
      # Use correct column name 'property_value' and add error handling
      record = find_by(property: 'petty.cash.limit')
      record ? record.property_value.to_f : 40_000
    end
  end

  def self.lunch_allowance
    Rails.cache.fetch('global_properties/lunch_allowance', expires_in: 1.hour) do
      record = find_by(property: 'per.diem.lunch')
      record ? record.property_value.to_f : 0
    end
  end

  def self.dinner_allowance
    Rails.cache.fetch('global_properties/dinner_allowance') do
      record = find_by(property: 'per.diem.dinner')
      record ? record.property_value.to_f : 0
    end
  end

  def self.accommodation
    Rails.cache.fetch('global_properties/accommodation') do
      record = find_by(property: 'per.diem.accommodation')
      record ? record.property_value.to_f : 0
    end
  end

  def self.unit_fuel_cost
    Rails.cache.fetch('global_properties/unit_fuel_cost', expires_in: 1.hour) do
      record = find_by(property: 'unit.fuel.cost')
      record ? record.property_value.to_f : 0
    end
  end
end
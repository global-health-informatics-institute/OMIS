class GlobalProperty < ApplicationRecord
  def self.petty_cash_limit
    Rails.cache.fetch('global_properties/petty_cash_limit', expires_in: 1.hour) do
      # Use correct column name 'property_value' and add error handling
      record = find_by(property: 'petty.cash.limit')
      record ? record.property_value.to_f : 40_000
    end
  end
  def self.purchase_request_threshold
    Rails.cache.fetch('global_properties/purchase_request_threshold') do 
      record = find_by(property: 'purchase.request.threshold')
      record ? record.property_value.to_f : 3000000
    end
  end

end
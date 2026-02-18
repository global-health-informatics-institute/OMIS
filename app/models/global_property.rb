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

  # Template URL methods
  def self.purchase_request_template_url
    Rails.cache.fetch('global_properties/purchase_request_template_url', expires_in: 1.hour) do
      record = find_by(property: 'purchase_request_template_url')
      record&.property_value
    end
  end

  def self.travel_request_template_url
    Rails.cache.fetch('global_properties/travel_request_template_url', expires_in: 1.hour) do
      record = find_by(property: 'travel_request_template_url')
      record&.property_value
    end
  end

  def self.activity_request_template_url
    Rails.cache.fetch('global_properties/activity_request_template_url', expires_in: 1.hour) do
      record = find_by(property: 'activity_request_template_url')
      record&.property_value
    end
  end

  def self.liquidation_form_template_url
    Rails.cache.fetch('global_properties/liquidation_form_template_url', expires_in: 1.hour) do
      record = find_by(property: 'liquidation_form_template_url')
      record&.property_value
    end
  end

  def self.travel_budget_template_url
    Rails.cache.fetch('global_properties/travel_budget_template_url', expires_in: 1.hour) do
      record = find_by(property: 'travel_budget_template_url')
      record&.property_value
    end
  end

  def self.activity_budget_template_url
    Rails.cache.fetch('global_properties/activity_budget_template_url', expires_in: 1.hour) do
      record = find_by(property: 'activity_budget_template_url')
      record&.property_value
    end
  end

end
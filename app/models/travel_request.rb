class TravelRequest < ApplicationRecord
  cattr_accessor :steps do
    %w[travel_details financial_details]
  end

  belongs_to :requisition, foreign_key: :requisition_id, primary_key: :requisition_id
  belongs_to :vehicle, class_name: 'Asset', foreign_key: 'asset_id', optional: true

  # Add these as attr_accessor
  attr_accessor :current_step,
                :lunch_allowance,
                :dinner_allowance,
                :accommodation,
                :unit_fuel_cost,
                :consumption,
                :vehicle_id,
                :purpose,
                :department,
                :project 

  validates :requisition_id, presence: true

  before_save :set_calculated_financials

  private

  def set_calculated_financials
    self.total_fuel_cost = calculate_total_fuel_cost
    self.total_allowance = calculate_total_allowance
  end

  def calculate_total_fuel_cost
    (unit_fuel_cost || 0) * (fuel_consumption || 0) * (distance || 0)
  end

  def calculate_total_allowance
    (lunch_allowance || 0) + (dinner_allowance || 0) + (accommodation || 0)
  end

  def return_date_after_departure_date
    if departure_date.present? && return_date.present? && return_date < departure_date
      errors.add(:return_date, "cannot be before the departure date")
    end
  end

  public

  def current_step_valid?
    case current_step
    when 'travel_details'
      destination.present? &&
      distance.present? &&
      traveler_names.present? &&
      departure_date.present? &&
      return_date.present?
    when 'financial_details'
      true
    else
      valid?
    end
  end
end

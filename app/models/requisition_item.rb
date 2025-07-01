class RequisitionItem < ApplicationRecord
  belongs_to :requisition, foreign_key: :requisition_id
  belongs_to :travel_request
    #  validating petty cash limit
    validate :petty_cash_limit
    #validates :value, presence: true, numericality: { greater_than_or_equal_to: 1.00 }
    private
  
    #  method for verifying if the entered amount is within the accepted range
    def petty_cash_limit
      return unless requisition&.requisition_type == 'Petty Cash'
  
      # call to GlobalProperty method
      max_limit = GlobalProperty.petty_cash_limit.to_f
      return if value.blank?
  
      if value.to_f > max_limit
        errors.add(:value, "Cannot exceed ₦#{max_limit}")
      end
    end   
end

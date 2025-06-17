class RequisitionItem < ApplicationRecord
  belongs_to :requisition, foreign_key: :requisition_id
  self.primary_key = 'requisition_item_id'

    #  validating petty cash limit
    validate :petty_cash_limit
    validate :purchase_request_threshold
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
    def purchase_request_threshold
            return unless requisition&.requisition_type == 'Purchase Request'
            max_limit = GlobalProperty.purchase_request_threshold.to_f
            return if value.blank?
            if value.to_f >max_limit
              errors.add(:value, "Cannot exceed N#{max_limit}")
            end
    end  
end

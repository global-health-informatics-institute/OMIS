class RequisitionDonor < ApplicationRecord
  belongs_to :requisition
  belongs_to :donor
end

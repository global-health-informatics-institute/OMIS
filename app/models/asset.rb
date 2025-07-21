class Asset < ApplicationRecord
  belongs_to :requisition, primary_key: :requisition_id, foreign_key: :requisition_id
end

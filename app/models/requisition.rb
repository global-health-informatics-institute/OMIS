class Requisition < ApplicationRecord
  belongs_to :user, :foreign_key =>  :initiated_by
  has_many :requisition_items, :foreign_key => :requisition_id
  has_many :requisition_notes, :foreign_key => :requisition_id
  has_one :workflow_state, :foreign_key => :workflow_state_id

end

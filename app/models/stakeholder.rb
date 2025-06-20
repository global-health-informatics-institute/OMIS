class Stakeholder < ApplicationRecord
  has_many :purchase_request_attachments, foreign_key: :stakeholder_id
end

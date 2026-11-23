# frozen_string_literal: true

# A supplier that may submit quotations for one or more requisition items.
class Supplier < ApplicationRecord
  has_many :requisition_item_quotations, dependent: :restrict_with_error

  validates :name, presence: true
  validates :mobile_number, presence: true
  validates :mobile_number, format: { with: /\A\d{7,10}\z/, message: 'must be a valid phone number' }
  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  default_scope { where(voided: false) }
end

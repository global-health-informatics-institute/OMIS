# frozen_string_literal: true

class CommitteeMeeting < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :purchase_request, class_name: 'PurchaseRequest', foreign_key: :requisition_id,
                                primary_key: :requisition_id
  belongs_to :committee, foreign_key: :committee_id
  belongs_to :scheduler, class_name: 'Employee', foreign_key: :scheduled_by

  scope :scheduled, -> { where(status: 'Scheduled') }

  validates :scheduled_on, :status, presence: true
  validate :scheduled_on_is_in_the_future

  private

  def scheduled_on_is_in_the_future
    return if scheduled_on.blank? || scheduled_on >= DateTime.current

    errors.add(:scheduled_on, 'must be in the future')
  end
end

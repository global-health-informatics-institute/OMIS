# frozen_string_literal: true

class CommitteeMembership < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :committee, foreign_key: :committee_id
  belongs_to :employee, foreign_key: :employee_id

  scope :active_on, lambda { |date = Date.current|
    where('started_on <= ? AND (ended_on IS NULL OR ended_on >= ?)', date, date)
  }

  validates :role, :started_on, presence: true
  validate :ended_on_is_not_before_started_on

  def active_on?(date = Date.current)
    started_on <= date && (ended_on.nil? || ended_on >= date)
  end

  private

  def ended_on_is_not_before_started_on
    return if ended_on.blank? || started_on.blank? || ended_on >= started_on

    errors.add(:ended_on, 'must be on or after the membership start date')
  end
end

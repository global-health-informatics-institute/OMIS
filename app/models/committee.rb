# frozen_string_literal: true

class Committee < ApplicationRecord # rubocop:disable Style/Documentation
  has_many :committee_memberships, foreign_key: :committee_id, dependent: :restrict_with_error
  has_many :members, through: :committee_memberships, source: :employee

  scope :active, -> { where(active: true) }

  validates :name, :short_name, presence: true
  validates :short_name, uniqueness: { case_sensitive: false }

  before_validation :normalize_short_name

  def active_memberships(on: Date.current)
    committee_memberships.active_on(on)
  end

  private

  def normalize_short_name
    self.short_name = short_name.to_s.strip.upcase
  end
end

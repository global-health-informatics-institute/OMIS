# frozen_string_literal: true

# Model representing a donor entity.
class Donor < ApplicationRecord
  has_many :donor_projects
  has_many :projects, through: :donor_projects

  scope :active, -> { where(voided: false) }
end

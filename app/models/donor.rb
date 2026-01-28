# frozen_string_literal: true

# Model representing a donor entity.
class Donor < ApplicationRecord
  scope :active, -> { where(voided: false) }
end

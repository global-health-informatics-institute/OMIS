# frozen_string_literal: true

# DonorProject model linking donors and projects
class DonorProject < ApplicationRecord
  belongs_to :donor
  belongs_to :project
end

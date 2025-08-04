# frozen_string_literal: true

class Log < ApplicationRecord # rubocop:disable Style/Documentation
  belongs_to :loggable, polymorphic: true
end

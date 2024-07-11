class InitialState < ApplicationRecord
  belongs_to :workflow_process
  has_one :workflow_state
end

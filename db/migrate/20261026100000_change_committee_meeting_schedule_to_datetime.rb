# frozen_string_literal: true

class ChangeCommitteeMeetingScheduleToDatetime < ActiveRecord::Migration[7.0]
  def change
    change_column :committee_meetings, :scheduled_on, :datetime
  end
end

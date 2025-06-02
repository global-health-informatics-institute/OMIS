class Comment < ApplicationRecord

  belongs_to :timesheet, foreign_key: :timesheet_id, primary_key: :timesheet_id
end

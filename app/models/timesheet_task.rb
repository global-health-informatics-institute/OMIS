class TimesheetTask < ApplicationRecord
  belongs_to :project, foreign_key: :project_id
  belongs_to :timesheet, foreign_key: :timesheet_id
end

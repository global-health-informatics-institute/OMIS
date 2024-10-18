def main()
  assign_timesheet_state
end

def assign_timesheet_state()
  unsubmitted = Timesheet.where(submitted_on: nil, approved_by: nil, approved_on: nil, state: nil)
  submitted = Timesheet.where.not(submitted_on: nil).where(approved_by: nil, approved_on: nil, state: nil)
  approved = Timesheet.where.not(submitted_on: nil, approved_by: nil, approved_on: nil).where(state: nil)

  unsubmitted.update(state: 6)
  submitted.update(state: 7)
  approved.update(state: 10)
end

main
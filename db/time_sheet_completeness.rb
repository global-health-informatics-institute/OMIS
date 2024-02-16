def start

  dates = []
  start_date = Date.parse('2023-12-01')
  (0..6).each do |i|
    dates.append(start_date.advance(weeks: i).cweek)
  end
  employees = Employee.where(still_employed: true)

  (employees || []).each do |employee|

    number = Timesheet.select("timesheet_week").where("employee_id = ? and timesheet_week >= ? ",
                                                      employee.employee_id, '2023-05-07').collect { |x| x.timesheet_week.cweek }
    missing_weeks =  dates - number
    weeks = missing_weeks.collect { |x|  Date.today.beginning_of_year.advance(weeks: x)}
    File.open("reports/#{employee.person.full_name.gsub(" ","_")}_missing_time_sheets.txt", "w") { |f| f.write weeks.join("\n") }
  end
end

start

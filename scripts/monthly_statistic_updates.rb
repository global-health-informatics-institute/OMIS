#this file is a monthly script to update different parameters

def main
  #add_leave_days
  #subtract_leave_days
  update_retention_turnover_rate
end

def add_leave_days
  puts "Adding leave days"
  employees = Employee.where("employment_date <= ? and COALESCE(departure_date, Date.today.end_of_month.strftime('%Y-%m-%d')) >= ?",
                             Date.today.beginning_of_month.strftime('%Y-%m-%d'),
                             Date.today.end_of_month.strftime('%Y-%m-%d'))
  ft_rate = GlobalProperty.find_by_property('full.time.annual.leave')
  pt_rate = GlobalProperty.find_by_property('part.time.annual.leave')
  (employees || []).each do |employee|

    summary = LeaveSummary.where(employee_id: employee.id, leave_type: "Annual Leave",
                                 financial_year: Date.today.year).first_or_create(leave_days_balance: 0.0,
                                                                                  leave_days_total: 0.0)


    if employee.employment_type.upcase == "FULL-TIME"
      summary.leave_days_total += (ft_rate.property_value.to_f)
      summary.leave_days_balance += (ft_rate.property_value.to_f)
    else
      summary.leave_days_total += (pt_rate.property_value.to_f)
      summary.leave_days_balance += (ft_rate.property_value.to_f)
    end

    summary.save
  end
end

def subtract_leave_days

  puts "subtracting leave days taken"
  prj = Project.where("short_name in (?)", ['Annual Leave', 'Paternity Leave','Compassionate Leave','Study Leave',
                                            'Sick Leave']).collect{|x| [x.id, x.short_name]}.to_h

  hrs = GlobalProperty.find_by_property('number.of.hours').property_value.to_f
  summaries=  TimesheetTask.joins("inner join timesheets on timesheet_tasks.timesheet_id=timesheets.timesheet_id").select(
    "timesheets.employee_id, project_id, sum(duration) as duration").where(
    "task_date between ? and ? and project_id in (?)", Date.today.beginning_of_month.strftime('%Y-%m-%d'),
    Date.today.end_of_month.strftime('%Y-%m-%d'), prj.keys).group(:employee_id,:project_id)

  (summaries || []).each do |summary|
    leave = LeaveSummary.where(employee_id: summary.employee_id, leave_type: prj[summary.project_id],
                               financial_year: Date.today.year).first_or_create(leave_days_balance: 0.0,
                                                                                leave_days_total: 0.0)

    leave.leave_days_balance -= (summary.duration / hrs)
    leave.save
  end
end

def update_retention_turnover_rate
  # Retention rate is (# of emp. on last day - # of emp. hired in period) / # of emp. on first day
  # Turnover rate is # of emp. who left / average # of emps.
  # Average number of emps is average of # of emp. on first day and # of emp. on last day

  puts "Calculating retention rate in recent quarter"
  qtr_start_date = Date.today.prev_quarter.beginning_of_quarter
  qtr_end_date = Date.today.prev_quarter.end_of_quarter
  emp_on_first_day = Employee.where("COALESCE(departure_date, '#{qtr_start_date}') >= ? and employment_date < ?",
                                    qtr_start_date, qtr_start_date).count

  emp_on_last_day = Employee.where("COALESCE(departure_date, '#{qtr_end_date}') >= ? and employment_date <= ?",
                                   qtr_end_date, qtr_end_date).count
  hired_in_period = Employee.where("employment_date between ? and ?", qtr_start_date, qtr_end_date).count

  left_in_period = Employee.where("departure_date between ? and ?", qtr_start_date, qtr_end_date).count

  retention_rate = ((emp_on_last_day - hired_in_period)/emp_on_first_day.to_f)

  turnover_rate = (left_in_period / ((emp_on_first_day+ emp_on_last_day) / 2.0))

  update_reporting_statistics(qtr_start_date, qtr_end_date,
                              "#{qtr_start_date.year}-Q#{((qtr_start_date.month.to_i+2)/3).ceil}", retention_rate,
                              'Retention Rate' )

  update_reporting_statistics(qtr_start_date, qtr_end_date,
                              "#{qtr_start_date.year}-Q#{((qtr_start_date.month.to_i+2)/3).ceil}", turnover_rate,
                              'Turnover Rate' )

end


def update_overtime_hours

end


def update_reporting_statistics(start_date, end_date, label, value, description)
  statistic = ReportStatistic.where(period_start: start_date, period_end: end_date,
                                    statistic_description: description).first

  statistic =  ReportStatistic.new if statistic.blank?

  statistic.period_start = start_date
  statistic.period_end = end_date
  statistic.period_label = label
  statistic.statistic_description = description
  statistic.statistic_value = value
  statistic.save
end

main
def main
  update_retention_turnover_rate
end

def update_retention_turnover_rate
  # Retention rate is (# of emp. on last day - # of emp. hired in period) / # of emp. on first day
  # Turnover rate is # of emp. who left / average # of emps.
  # Average number of emps is average of # of emp. on first day and # of emp. on last day

  earliest_date =  Employee.select('employment_date').order('employment_date asc').first.employment_date

  while (earliest_date < Date.today)
    puts "Calculating retention rate in recent quarter"
    qtr_start_date = earliest_date.beginning_of_quarter
    qtr_end_date = earliest_date.end_of_quarter
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

    earliest_date = earliest_date.advance(months: 3)
  end
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
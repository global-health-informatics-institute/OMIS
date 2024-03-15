def add_leave_days
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

add_leave_days

module XslMonthlyLoeReport
  def self.initialize_report(employees, results, projects, cost_shared,loes, start_date, end_date)
    file_name = "#{start_date.gsub('-', '').squish}_#{end_date.gsub('-', '').squish}_org_loe_report.xsl"
    book = Spreadsheet::Workbook.new
    hours_sheet = book.create_worksheet(name: 'HoursWorked')


    loe_sheet = book.create_worksheet(name: 'LOE')
    payroll_sheet = book.create_worksheet(name: 'FullPayroll')
    payroll_sheet.row(0).push('#','Employee Name','Gross Pay','PAYE','Employer Pension','Employee Pension',
                               'Group Life','Pension & LA Admin. Fee','Pension & LA Admin. Fee VAT', 'Tevet Levy',
                               'Health Insurance', 'Total Cost')
    hours_sheet.row(0).concat(['#','Employee Name'] + projects.values)
    loe_sheet.row(0).concat(['#','Employee Name'] + projects.values)

    count = 1
    (results || []).each do |person_id, values|
      add_full_payroll(count, employees[person_id], payroll_sheet)
      add_hours_worked(count, employees[person_id],values, projects,cost_shared[person_id], hours_sheet, loes[person_id])
      count += 1
    end

    book.write "tmp/#{file_name}"
    file_name
  end

  def self.add_full_payroll(count, name, sheet)
    sheet.row(count).push(count, name, '', "=C#{count+1}","=C#{count+1}*0.1",
                          "=C#{count+1}*0.05", "=C#{count+1}*0.0112","=C#{count+1}*0.008",
                          "=C#{count+1}*0.008*0.165", "=C#{count+1}*0.01", 50000,
                          "=C#{count+1}+E#{count+1}+E#{count+1}+G#{count+1}+H#{count+1}+I#{count+1}+J#{count+1}+K#{count+1}")
  end

  def self.add_hours_worked(count, emp_name, records, projects, cost_shared_hrs,sheet, loes)

    sheet.row(count).push(count, emp_name)
    (projects || []).keys.each do |project|
      temp_add_hrs = loes[project].blank? ? 0.0 : (cost_shared_hrs * (loes[project]/100)) rescue 0.0
      main_hrs = records[project].blank? ? 0.0 : records[project]
      sheet.row(count).push(( main_hrs + temp_add_hrs))
    end
  end
  def add_loe

  end
end
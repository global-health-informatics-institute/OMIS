def main (start_date = "2023-12-26", end_date= "2024-01-25")

  employees = Employee.all
  (employees || []).each do |emp|
    data, total = get_details(emp.id, start_date, end_date)
    padding = (Date.parse(start_date).cwday == 0 ? 0 : ((Date.parse(start_date).cwday.to_i) -1) )
    pre_processed= pdf_preprocess(padding, data, Date.parse(start_date))
    person = emp.person.full_name.gsub(" ", "_")
    pdf_it(pre_processed, person, "#{start_date} - #{end_date}", emp.person.full_name, total)
    #format_report(data)
  end
end

def pdf_it(data, file_name, period, name, total)
  Prawn::Document.generate("docs/#{file_name}_timesheet.pdf", :page_size => 'A3', :page_layout => :landscape,
                           left_margin: 40, right_margin: 30 ) do |pdf|
    pdf.image "scripts/ghii-seed/letterhead_landscape.png", width: 1100, height: 100
    pdf.move_down 20
    pdf.font_size 12
    pdf.text "<font size='16'><b>Employee Monthly Timesheet Report</b></font>", align: :center, inline_format: true
    pdf.move_down 20
    pdf.text "<b>Period:</b> #{period}", inline_format: true
    pdf.font_size 10
    pdf.move_down 20
    pdf.table(data)
    pdf.move_down 60
    pdf.text "Total Hours: #{Prawn::Text::NBSP*1}#{total}"
    pdf.move_down 40
    pdf.text "Employee Name: #{Prawn::Text::NBSP*1}#{name} #{Prawn::Text::NBSP*180}Supervisor Name: ___________________________________"
    pdf.move_down 40
    pdf.text "Date: #{Prawn::Text::NBSP*1}_____________________________________________ #{Prawn::Text::NBSP*150}Date: _____________________________________________"
    pdf.move_down 60
    pdf.text "Signature:  #{Prawn::Text::NBSP*1}________________________________________ #{Prawn::Text::NBSP*150}Signature: __________________________________________"
  end
end

def pdf_preprocess(padding, data,start_date)

  dataset = [
    ["Project" + " "*30, {:content => "First Week", :colspan => 7}, {:content => "Second Week", :colspan => 7},
     {:content => "Third Week", :colspan => 7}, {:content => "Fourth Week", :colspan => 7},
     {:content => "Fifth Week", :colspan =>7}],
    %w[Day Sun Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed Thu Fri Sat]
  ]

  header = ["Date"]
  (0..padding).each do |pad|
    header.append(" ")
  end
  (0..30).each do |i|
    header.append(start_date.advance(days: i).strftime('%d'))
  end
  (0..(35-header.length)).each do |pad|
    header.append(" ")
  end
  dataset.append(header)

  (data || []).each do |project_id, records|
    project_record = [Project.find(project_id).short_name]
    (0..padding).each do |pad|
      project_record.append(" ")
    end
    (0..30).each do |i|
      project_record.append(records[start_date.advance(days: i).strftime('%d').to_i])
    end
	(0..(35-project_record.length)).each do |pad|
    	project_record.append(" ")
	end
    dataset.append(project_record)
  end
  return dataset
end

def format_report(records)
  book = Spreadsheet::Workbook.new # We have created a new object of the Spreadsheet book

  sheet = book.create_worksheet(name: 'First sheet') # We are creating new sheet in the Spreadsheet(We can create multiple sheets in one Spreadsheet book)

  # syntax to create new row is as the following:
  # sheet.row(row_number).push(column first', 'column second', 'column third')

  sheet.row(0).push('Employee Name')
  (projects || []).each do |project|
    sheet.row(0).push(project)
  end

  i = 1
  (records || []).each do |k, v|
    sheet.row(i).push(k)
    (projects || []).each do |project|
      sheet.row(i).push(v[project])
    end
    i+=1
  end
  # Write this sheet's contain to the test.xls file.
  book.write 'docs/loe_report.xls'

end

def get_details(employee_id, start_date, end_date)

  sheets = Timesheet.where("employee_id = ? and timesheet_week between ? and ?",
                           employee_id, Date.parse(start_date).advance(weeks: -1), end_date)
  records = TimesheetTask.where("timesheet_id in (?) and task_date between ? and ? ",
                                sheets.collect { |x| x.timesheet_id },start_date, end_date)

  total = 0.0

  daily_summary = {}
  (records || []).each do |record|
    if daily_summary[record.project_id].blank?
      daily_summary[record.project_id] = {record.task_date.day => record.duration.round(2)}
    else
      check = daily_summary[record.project_id][record.task_date.day]
      daily_summary[record.project_id][record.task_date.day] = (check.blank? ? record.duration.round(2) : (check + record.duration.round(2)))
    end
    total += record.duration.round(2)
  end
  return daily_summary, total
end

main

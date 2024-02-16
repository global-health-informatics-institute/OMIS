module ReportsHelper
  def select_report
    options = [['HR Report', 'HR'], ['Asset Status', 'Assets'],
               ['Monthly Individual LOE Report', 'Employee LOE'],
               ['Monthly Organization LOE Report', 'Org LOE'],
               ['Project Progress Report','Project Report']
    ]
    return options
  end

  def employees_LOE_list
    employees = Employee.where(still_employed: true).collect{|x| [x.person.full_name, x.employee_id]}
    return employees
  end

  def monthly_loe_report(records, projects)
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
    book.write 'tmp/loe_report.xsl'

  end

  def monthly_employee_loe_spreadsheet(records, start_day, end_day, employee_name)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet(name: 'Monthly Employee LOE Report')

    # Add headers and data to the sheet based on the records and projects
    sheet.row(0).push('Employee Name')
    (records || []).each do |employee_name, project|
      sheet.row(0).push(project)
    end

    i = 1
    (records || []).each do |employee_name, project_data|
      sheet.row(i).push(employee_name)
      (project_data || []).each do |project, loe|
        sheet.row(i).push(loe || 0.0)
      end
      i += 1
    end

    # Write the sheet to the Excel file
    book.write 'tmp/monthly_employee_loe_report.xls'
  end

  def monthly_employee_loe_pdf(records, start_day, end_day, employee_name)
    Prawn::Document.generate('tmp/monthly_employee_loe_report.pdf', :page_layout => :landscape) do |pdf|
      pdf.text 'Monthly Employee LOE Report', style: :bold, size: 16
      pdf.move_down 20
  
      # Table headers
      pdf.font_size 12
      pdf.text "Employee Name: #{@person.person.full_name}", style: :bold
  
      table_data = [['Project'] + (1..@last_day).map { |day| "Day #{day}" }]
  
      (records || []).each do |project_id, loe|
        project = Project.find(project_id)
        row = ["#{project.short_name}"]
        (1..@last_day).each do |day|
          duration = loe[day].blank? ? '-' : loe[day].floor(2)
          row << duration
        end
        table_data << row
      end
  
      pdf.table(table_data, header: true, cell_style: {size:9}, width: pdf.bounds.width) do
        row(0).font_style = :bold
        columns(0).align = :center
      end
    end
  end
  
end

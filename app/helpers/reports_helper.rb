module ReportsHelper
  def select_report
    options = [['HR Report', 'HR'], ['Asset Status', 'Assets'],
               ['Monthly Individual LOE Report', 'Employee LOE'],
               ['Monthly Organization LOE Report', 'Org LOE'],
               ['Project Progress Report','Project Report']
    ]
    return options
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
    book.write 'tmp/loe_report.xls'

  end
end

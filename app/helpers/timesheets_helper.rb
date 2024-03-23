module TimesheetsHelper
  def weekly_spreadsheet(records, projects, timesheet)
    book = Spreadsheet::Workbook.new # We have created a new object of the Spreadsheet book

    sheet = book.create_worksheet(name: 'First sheet') # We are creating new sheet in the Spreadsheet(We can create multiple sheets in one Spreadsheet book)

    # syntax to create new row is as the following:
    # sheet.row(row_number).push(column first', 'column second', 'column third')

    sheet.row(0).push('Project', 'Task')
    (0..6).each do |day|
      sheet.row(0).push(timesheet.timesheet_week.advance(:days => day).strftime("%a, %b %d"))
    end

    i = 1
    
    (records || []).each do |k, v|
      (v || []).each do |task, entries|
        sheet.row(i).push(projects[k].to_s)
        sheet.row(i).push(task.to_s)
        (0..6).each do |day|
          sheet.row(i).push((entries[day].blank? ? '-'.to_s : entries[day][:duration]).to_s)
        end
        i+=1
      end
    end
    # Write this sheet's contain to the test.xls file.
    book.write 'tmp/timesheet.xls'

  end

  def weekly_pdf(records, projects, timesheet)

    Prawn::Document.generate('tmp/timesheet.pdf', :page_layout => :landscape ) do |pdf|
      table_data = []
      titles = %w[Project Task]
      (0..6).each do |day|
        titles.append(timesheet.timesheet_week.advance(:days => day).strftime("%a, %b %d"))
      end

      table_data.append(titles)
      (records || []).each do |k, v|
        (v || []).each do |task, entries|
          row = []
          row.append(projects[k].to_s)
          row.append(task.to_s)
          (0..6).each do |day|
            row.append((entries[day].blank? ? '-' : entries[day]).to_s)
          end
          table_data.append(row)
        end
      end

      pdf.table(table_data, :width => 1500, :cell_style => { :inline_format => true })
    end
  end
end

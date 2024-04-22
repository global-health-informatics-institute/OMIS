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
    
    Prawn::Document.generate('tmp/timesheet.pdf', page_size: 'A3', page_layout: :landscape,
    left_margin: 40, right_margin: 30 ) do |pdf|
      pdf.image 'app/assets/images/GHII-Letterhead.png', width: 1100, height: 100
      pdf.move_down 40
      table_data = []
      titles = %w[Project Task]
      [7,1,2,3,4,5,6].each do |day|
        titles.append(timesheet.timesheet_week.advance(:days => day).strftime("%a, %b %d"))
      end

      table_data.append(titles)
      (records || []).each do |k, v|
        (v || []).each do |task, entries|
          row = []
          row.append(projects[k].to_s)
          row.append(task.to_s)
          [7,1,2,3,4,5,6].each do |day|
            row.append((entries[day].blank? ? '-' : entries[day][:duration]).to_s)
          end
          table_data.append(row)
        end
      end

      pdf.table(table_data, :width => 1100, :cell_style => { :inline_format => true })
      pdf.move_down 40
      pdf.text "Employee Name: #{Prawn::Text::NBSP*1}#{@person.person.full_name} #{Prawn::Text::NBSP*110}Supervisor Name: ___________________________________"
      pdf.move_down 40
      pdf.text "Date: #{Prawn::Text::NBSP*1}_____________________________________________ #{Prawn::Text::NBSP*120}Date: _____________________________________________"
      pdf.move_down 60
      pdf.text "Signature:  #{Prawn::Text::NBSP*1}________________________________________ #{Prawn::Text::NBSP*120}Signature: __________________________________________"
      pdf.start_new_page
    end
  end
end

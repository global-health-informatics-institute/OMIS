# frozen_string_literal: true

module TimesheetsHelper # rubocop:disable Style/Documentation
  def weekly_spreadsheet(records, projects, timesheet) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
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

  def _state_section_builder(timesheet) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    status = timesheet.current_status
    case status
    when 'pending Submission'
      pdf.text "Timesheet State: #{Prawn::Text::NBSP * 1}#{status}"
      pdf.move_down 40
    when 'Submitted'
      pdf.text "Timesheet State: #{Prawn::Text::NBSP * 1}#{status} #{Prawn::Text::NBSP * 110}Submitted on: #{timesheet[:submitted_on]}" # rubocop:disable Layout/LineLength
      pdf.move_down 40
    when 'Approved'
      pdf.text "Timesheet State: #{Prawn::Text::NBSP * 1}#{status} #{Prawn::Text::NBSP * 110}Approved by: #{@Person.full_name}" # rubocop:disable Layout/LineLength
      pdf.move_down 40
      pdf.text "Submitted On: #{Prawn::Text::NBSP * 1}#{timesheet[:submitted_on]} #{Prawn::Text::NBSP * 110}Approved On: #{timesheet[:approved_on]}" # rubocop:disable Layout/LineLength
      pdf.move_down 40
    when 'Recalled'
      pdf.text "Timesheet State: #{Prawn::Text::NBSP * 1}#{status} #{Prawn::Text::NBSP * 110}Initially Submitted on: #{timesheet[:submitted_on]}" # rubocop:disable Layout/LineLength
      pdf.move_down 40
      pdf.text "Recalled on: #{Prawn::Text::NBSP * 1}#{timesheet[:updated_at]}"
      pdf.move_down 40
    when 'Re-opened'
      pdf.text "Timesheet State: #{Prawn::Text::NBSP * 1}#{status} #{Prawn::Text::NBSP * 110}Initially Submitted on: #{timesheet[:submitted_on]}" # rubocop:disable Layout/LineLength
      pdf.move_down 40
      pdf.text "Re-open: #{Prawn::Text::NBSP * 1}#{timesheet[:updated_at]}"
      pdf.move_down 40
    when 'Re-submitted'
      pdf.text "Timesheet State: #{Prawn::Text::NBSP * 1}#{status} #{Prawn::Text::NBSP * 110}Initially Submitted on: #{timesheet[:submitted_on]}" # rubocop:disable Layout/LineLength
      pdf.move_down 40
      pdf.text "Re-submitted On: #{Prawn::Text::NBSP * 1}#{timesheet[:updated_at]}"
      pdf.move_down 40
    end
  end

  def weekly_pdf(records, projects, timesheet) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
    Prawn::Document.generate('tmp/timesheet.pdf', page_size: 'A3', page_layout: :landscape, # rubocop:disable Metrics/BlockLength
                                                  left_margin: 40, right_margin: 30 ) do |pdf|
      pdf.image 'app/assets/images/GHII-Letterhead.png', width: 1100, height: 120
      pdf.move_down 40
      table_data = []
      titles = %w[Project Task]
      [7, 1, 2, 3, 4, 5, 6].each do |day|
        titles.append(timesheet.timesheet_week.advance(days: day).strftime('%a, %b %d'))
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

      pdf.table(table_data, width: 1100, cell_style: { inline_format: true })
      pdf.move_down 40
      pdf.text "Employee Name: #{Prawn::Text::NBSP * 1}#{@person.person.full_name} #{Prawn::Text::NBSP * 110}Supervisor Name: ___________________________________" # rubocop:disable Layout/LineLength
      pdf.move_down 40
      pdf.text "Date: #{Prawn::Text::NBSP * 1}_____________________________________________ #{Prawn::Text::NBSP * 120}Date: _____________________________________________" # rubocop:disable Layout/LineLength
      pdf.move_down 60
      pdf.text "Signature:  #{Prawn::Text::NBSP * 1}________________________________________ #{Prawn::Text::NBSP * 120}Signature: __________________________________________" # rubocop:disable Layout/LineLength
      pdf.start_new_page
    end
  end
end

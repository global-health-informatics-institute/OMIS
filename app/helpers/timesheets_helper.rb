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

  def _state_section_builder(pdf:, timesheet:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    status = timesheet.current_status
    case status

    when 'Pending Submission'
      _write_line(
        pdf:,
        previous_text: "Timesheet State: #{Prawn::Text::NBSP * 1}#{status}"
      )

    when 'Submitted'
      _write_line(
        pdf:,
        previous_text: "Timesheet State: #{Prawn::Text::NBSP}#{status}",
        next_text: "Submitted on: #{timesheet[:submitted_on]&.in_time_zone&.strftime('%A, %d %B %Y at %H:%M') || '--'}"
      )
    when 'Approved'
      _write_line(
        pdf:,
        previous_text: "Timesheet State: #{Prawn::Text::NBSP}#{status}",
        next_text: "Submitted on: #{timesheet[:submitted_on]&.in_time_zone&.strftime('%A, %d %B %Y at %H:%M') || '--'}"
      )
      _write_line(
        pdf:,
        previous_text: "Submitted On: #{Prawn::Text::NBSP}#{timesheet[:submitted_on]}",
        next_text: "Approved On: #{timesheet[:approved_on]&.in_time_zone&.strftime('%A, %d %B %Y at %H:%M') || '--'}"
      )

    when 'Recalled'
      _write_line(
        pdf:,
        previous_text: "Timesheet State: #{Prawn::Text::NBSP}#{status}",
        next_text: "Re-called On: #{timesheet[:updated_at]&.in_time_zone&.strftime('%A, %d %B %Y at %H:%M') || '--'}"
      )

    when 'Rejected'
      _write_line(
        pdf:,
        previous_text: "Timesheet State: #{Prawn::Text::NBSP}#{status}",
        next_text: "Rejected On: #{timesheet[:updated_at]&.in_time_zone&.strftime('%A, %d %B %Y at %H:%M') || '--'}"
      )

    when 'Re-opened'
      _write_line(
        pdf:,
        previous_text: "Timesheet State: #{Prawn::Text::NBSP}#{status}",
        next_libne: "Submitted On: #{timesheet[:submitted_on]&.in_time_zone&.strftime('%A, %d %B %Y at %H:%M') || '--'}"
      )
      _write_line(
        pdf:,
        previous_text: "Re-opened On: #{Prawn::Text::NBSP}#{timesheet[:updated_at]&.in_time_zone&.strftime('%A, %d %B %Y at %H:%M') || '--'}" # rubocop:disable Layout/LineLength
      )

    when 'Re-submitted'
      _write_line(
        pdf:,
        previous_text: "Timesheet State: #{Prawn::Text::NBSP * 1}#{status}",
        next_text: "Re-submitted On: #{timesheet[:submitted_on]&.in_time_zone&.strftime('%A, %d %B %Y at %H:%M') || '--'}" # rubocop:disable Layout/LineLength
      )
    end
  end

  def weekly_pdf(records, projects, timesheet) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
    Prawn::Document.generate('tmp/timesheet.pdf', page_size: 'A3', page_layout: :landscape, # rubocop:disable Metrics/BlockLength
                                                  left_margin: 40, right_margin: 30 ) do |pdf|
      pdf.image 'app/assets/images/GHII-Letterhead.png', width: pdf.bounds.width
      pdf.move_down 20
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
      _write_line(
        pdf:,
        previous_text: "Employee Name: #{Prawn::Text::NBSP}#{@person.person.full_name}",
        next_text: "Supervisor Name: #{Prawn::Text::NBSP}#{@person.supervisor.person.full_name}"
      )
      _state_section_builder(pdf:, timesheet:)
      _add_footer(pdf:)
      _add_header(pdf:, timesheet:)
      _add_stamp(pdf:)
    end
  end

  def _dynamic_nbsp(pdf, previous_text, target_width = 550)
    text_width = pdf.width_of(previous_text)

    nbsp_width = pdf.width_of(Prawn::Text::NBSP)

    remaining_width = target_width - text_width

    count = [(remaining_width / nbsp_width).floor, 1].max

    Prawn::Text::NBSP * count
  end

  def _write_line(pdf:, previous_text:, next_text: '', move_down: 40)
    ensure_space(pdf:, required_height: 20)
    gap = _dynamic_nbsp(pdf, previous_text)

    pdf.text(
      "#{previous_text}" \
      "#{gap}" \
      "#{next_text}"
    )
    pdf.move_down move_down
  end

  def _add_header(pdf:, timesheet:)
    pdf.repeat(:all) do
      pdf.move_cursor_to pdf.bounds.top
      pdf.text "Timesheet ID: #{timesheet.id}", align: :right, Style: :bold, size: 14
    end
  end

  def _add_footer(pdf:) # rubocop:disable Metrics/MethodLength
    pdf.repeat(:all) do
      pdf.bounding_box([pdf.bounds.left, 30], width: pdf.bounds.width) do
        pdf.move_down 5
        pdf.stroke_horizontal_rule
        pdf.move_down 10
        pdf.text(
          "This document was generated by OMIS © Global Health Informatics Institute - #{Time.current.year}",
          size: 12,
          align: :center
        )
      end
    end
  end

  def _add_stamp(pdf:)
    pdf.repeat(:all) do
      pdf.image(
        'app/assets/images/GHII-stamp.png',
        width: pdf.bounds.width / 3,
        at: [
          pdf.bounds.right - (pdf.bounds.width / 3),
          350
        ]
      )
    end
  end

  def ensure_space(pdf:, required_height:)
    footer_zone = 100
    return unless pdf.cursor < footer_zone + required_height

    pdf.start_new_page
    pdf.move_down 10
  end
end

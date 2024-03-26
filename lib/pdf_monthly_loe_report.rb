# frozen_string_literal: true

module PdfMonthlyLoeReport
  def self.initialize_report(employees, results, projects, start_date, end_date)

    file_name = "#{start_date.gsub('-', '').squish}_#{end_date.gsub('-', '').squish}_org_loe_report.pdf"
    padding = Date.parse(start_date).cwday == 7 ? 0 : (Date.parse(start_date).cwday.to_i - 1)
    Prawn::Document.generate("tmp/#{file_name}", page_size: 'A3', page_layout: :landscape,
                             left_margin: 40, right_margin: 30) do |pdf_object|
      pdf_object.image 'app/assets/images/GHII-Letterhead.png', width: 1100, height: 100
      pdf_object.move_down 20
      pdf_object.text "<font size='16'><b>Monthly LOE Report</b></font>", align: :center, inline_format: true
      pdf_object.move_down 20

      (results || []).each do |project, records|
        data_rows = [[projects[project], 'Employee Name', 'Number of Hours', 'Actual LOE', 'Projected LOE']]
        (records || []).each do |record|
          data_rows.append([projects[project], employees[record[:employee]], record[:hours].floor(2), '' ,
                            record[:projected_loe]])
        end
        pdf_object.table(data_rows)
        pdf_object.move_down 20
        pdf_object.start_new_page
      end

      (employees || []).each do |employee_id,  name|
        data, total = get_emp_details(employee_id, start_date, end_date)
        weeks = ((Date.parse(end_date) - Date.parse(start_date)) / 7.0).floor
        required_pages = (weeks / 5).floor
        (0..required_pages).each do |i|
          temp_start_date = Date.parse(start_date).advance(weeks: (5 * i))
          temp_end_date = temp_start_date.advance(weeks: 5)
          period = "#{temp_start_date.strftime('%d %b, %Y')} - #{temp_end_date.strftime('%d %b, %Y')}"
          pre_processed = pdf_preprocess(padding, data, temp_start_date, temp_end_date)
          pdf_object.image 'app/assets/images/GHII-Letterhead.png', width: 1100, height: 100
          pdf_object.move_down 20
          pdf_object.font_size 12
          pdf_object.text "<font size='16'><b>Employee Monthly Timesheet Report</b></font>", align: :center, inline_format: true
          pdf_object.move_down 20
          pdf_object.text "<b>Period:</b> #{period}", inline_format: true
          pdf_object.font_size 10
          pdf_object.move_down 20
          pdf_object.table(pre_processed)
          pdf_object.move_down 60
          pdf_object.text "Total Hours: #{Prawn::Text::NBSP*1}#{total}"
          pdf_object.move_down 40
          pdf_object.text "Employee Name: #{Prawn::Text::NBSP*1}#{name} #{Prawn::Text::NBSP*180}Supervisor Name: ___________________________________"
          pdf_object.move_down 40
          pdf_object.text "Date: #{Prawn::Text::NBSP*1}_____________________________________________ #{Prawn::Text::NBSP*150}Date: _____________________________________________"
          pdf_object.move_down 60
          pdf_object.text "Signature:  #{Prawn::Text::NBSP*1}________________________________________ #{Prawn::Text::NBSP*150}Signature: __________________________________________"
          pdf_object.start_new_page
        end
      end
    end
    file_name
  end

  def self.pdf_preprocess(padding,data, start_date, end_date)
    # dataset = [
    #   ["Project#{' '*40}", {content: 'First Week', colspan: 7}, {content: 'Second Week', colspan: 7},
    #    {content: 'Third Week', colspan: 7}, {content: 'Fourth Week', colspan: 7},
    #    {content: 'Fifth Week', colspan: 7}, {content: 'Sixth Week', colspan: 7}],
    #   ['Day'] + %w[Sun Mon Tue Wed Thu Fri Sat]*6
    # ]

    number_of_weeks = ((end_date - start_date).to_i / 7.0).floor
    number_of_days = (end_date - start_date).to_i

    dataset = [["Project#{' '*30}"] + (1..number_of_weeks).flat_map { |week|
              [{content: "Week#{week}", colspan: 7}]}] + [['Day'] + 
              %w[Sun Mon Tue Wed Thu Fri Sat] * number_of_weeks]

    header = ['Date']
    (0..padding).each do |pad|
      header.append(' ')
    end
    (0..number_of_days - 2).each do |i|
      header.append(start_date.advance(days: i).strftime('%d'))
    end
    (0..(35-header.length)).each do |pad|
      header.append(' ')
    end
    dataset.append(header)

    (data || []).each do |project_id, records|
      project_record = [Project.find(project_id).short_name]
      (0..padding).each do |pad|
        project_record.append(' ')
      end
      (0..number_of_days - 2).each do |i|
        project_record.append(records[start_date.advance(days: i).strftime('%d').to_i])
      end
      (0..(35-project_record.length)).each do |pad|
        project_record.append(' ')
      end
      dataset.append(project_record)
    end
    dataset
  end

  def self.get_emp_details(employee_id, start_date, end_date)

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
    #raise daily_summary.inspect
    [daily_summary, total]
  end
end
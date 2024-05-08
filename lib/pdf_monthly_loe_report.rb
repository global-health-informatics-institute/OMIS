# frozen_string_literal: true

module PdfMonthlyLoeReport
  def self.initialize_report(employees, results, projects, start_date, end_date)

    file_name = "#{start_date.gsub('-', '').squish}_#{end_date.gsub('-', '').squish}_org_loe_report.pdf"

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

      (employees || []).each do |employee_id, name|
        weeks = ((Date.parse(end_date) - Date.parse(start_date)) / 7.0).floor
        required_pages = (weeks / 5).floor

        (0..required_pages).each do |i|
          temp_start_date = Date.parse(start_date).advance(weeks: (5 * i)) #.beginning_of_week
          temp_end_date = (required_pages > 0 ? temp_start_date.advance(weeks: 5) :  Date.parse(end_date)).end_of_week
          padding = temp_start_date.cwday == 7 ? 0 : temp_start_date.cwday.to_i

          period = "#{temp_start_date.strftime('%d %b, %Y')} - #{temp_end_date.strftime('%d %b, %Y')}"
          data, total = get_emp_details(employee_id, temp_start_date, temp_end_date)
          pre_processed = pdf_preprocess(padding, data, temp_start_date, temp_end_date)
          pdf_object.image 'public/letterhead_landscape.png', width: 1100, height: 100
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

    number_of_weeks = ((end_date - start_date).to_i / 7.0).floor
    number_of_days = (end_date - start_date).to_i - 1

    dataset = [["Project#{' '*30}"] + (1..(number_of_weeks+1)).flat_map { |week|
              [{content: "Week #{week}", colspan: 7}]}] + [['Day'] +
              %w[Sun Mon Tue Wed Thu Fri Sat] * (number_of_weeks+1)]

    header = ['Date'] + ([''] * padding)

    (0..(number_of_days+1)).each do |i|
      header.append(start_date.advance(days: i).strftime('%d'))
    end
    (0..(35-header.length)).each do |pad|
      header.append(' ')
    end
    dataset.append(header)

    (data || []).each do |project_id, records|
      project_record = [Project.find(project_id).short_name] + ([''] * padding)

      (0..number_of_days).each do |i|
        temp_date = start_date.advance(days: i)
        project_record.append(records["#{temp_date.day}#{temp_date.month}"])
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
                             employee_id, start_date, end_date)
    records = TimesheetTask.where("timesheet_id in (?) and task_date between ? and ? ",
                                  sheets.collect { |x| x.timesheet_id },start_date, end_date)

    total = 0.0

    daily_summary = {}
    (records || []).each do |record|
      if daily_summary[record.project_id].blank?
        daily_summary[record.project_id] = {"#{record.task_date.day}#{record.task_date.month}" => record.duration.round(2)}
      else
        check = daily_summary[record.project_id]["#{record.task_date.day}#{record.task_date.month}"]
        daily_summary[record.project_id]["#{record.task_date.day}#{record.task_date.month}"] = (check.blank? ? record.duration.round(2) : (check + record.duration.round(2)))
      end
      total += record.duration.round(2)
    end
    
    [daily_summary, total]
  end
end
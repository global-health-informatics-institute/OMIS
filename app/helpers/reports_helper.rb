module ReportsHelper
  def select_report
    options = [['HR Report', 'HR'], ['Asset Status', 'Assets'],
               ['Individual LOE Report', 'Employee LOE'],
               ['Organization LOE Report', 'Org LOE'],
               ['Project Progress Report','Project Report'],
               ['Token Request Report', 'Tokens'],
               ['Token Request Report', 'Tokens'],
               ['Leave Days Report', 'Leave days'],
               ['Petty Cash Report', 'Petty Cash']
    ]
    return options
  end

  def employees_LOE_list
    employees = Employee.where(still_employed: true).collect{|x| [x.person.full_name, x.employee_id]}
    return employees
  end

  def monthly_loe_report(records, projects, employee_name)
    book = Spreadsheet::Workbook.new # We have created a new object of the Spreadsheet book

    sheet = book.create_worksheet(name: 'First sheet') # We are creating new sheet in the Spreadsheet(We can create multiple sheets in one Spreadsheet book)

    # syntax to create new row is as the following:
    # sheet.row(row_number).push(column first', 'column second', 'column third')

    sheet.row(0).push("Employee Namessss:  #{@person.person.full_name}")
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

  def monthly_employee_loe_pdf(records, start_day, end_day, employee_name)
    Prawn::Document.generate('tmp/monthly_employee_loe_report.pdf',:page_size => 'A3', :page_layout => :landscape,
                             left_margin: 40, right_margin: 30) do |pdf|
      pdf.image "app/assets/images/GHII-Letterhead.png", width: 1100, height: 120
      pdf.move_down 20
      pdf.font_size 12
      pdf.text "<font size='16'><b>Employee Monthly Timesheet Report</b></font>", align: :center, inline_format: true
      pdf.move_down 20
      pdf.text "<b>Period:</b> #{@first_day}   -   #{@last_date}", inline_format: true
      pdf.move_down 10

      table_data = [['Project' + " "*30, {:content => "First Week", :colspan => 7}, {:content => "Second Week", :colspan => 7},
      {:content => "Third Week", :colspan => 7}, {:content => "Fourth Week", :colspan => 7},
      {:content => "Fifth Week", :colspan =>7}],
     %w[Day Sun Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed Thu Fri Sat Sun Mon Tue Wed Thu Fri Sat]]
  
      date_row = ['Date']
      (1..31).each do |day|
        date_row << day.to_s
      end
      table_data << date_row
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
      pdf.font_size 10
      pdf.move_down 60
      pdf.text "Total Hours: #{Prawn::Text::NBSP*1}#{@total}"
      pdf.move_down 40
      pdf.text "Employee Name: #{Prawn::Text::NBSP*1}#{@person.person.full_name} #{Prawn::Text::NBSP*150}Supervisor Name: ___________________________________"
      pdf.move_down 40
      pdf.text "Date: #{Prawn::Text::NBSP*1}_____________________________________________ #{Prawn::Text::NBSP*100}Date: _____________________________________________"
      pdf.move_down 60
      pdf.text "Signature:  #{Prawn::Text::NBSP*1}________________________________________ #{Prawn::Text::NBSP*100}Signature: __________________________________________"
    end
  end

  def group_by_project(sheets, cost_shared_prjs)
    results = {}
    cost_shared_hours = Hash.new(0)

    (sheets || []).each do |sheet|
      prj_loe = begin
                  ProjectTeam.where("start_date <= ? and project_id = ? and employee_id = ? and
           COALESCE(end_date, '#{Date.today}') >= ? ", params[:start_date], sheet.project_id,
                                    sheet.employee_id, params[:end_date]).first.allocated_effort
                rescue StandardError
                  0.00
                end

      if cost_shared_prjs.include?(sheet.project_id)
        cost_shared_hours[sheet.employee_id] += sheet.duration
      else
        if results[sheet.project_id].blank?
          results[sheet.project_id] = [{ employee: sheet.employee_id, hours: sheet.duration, projected_loe: prj_loe }]
        else
          results[sheet.project_id].append({ employee: sheet.employee_id, hours: sheet.duration,
                                              projected_loe: prj_loe })
        end
      end
    end

    projects_array = Project.find(results.keys).collect { |x| [x.id, x.short_name] }.to_h

    return results, cost_shared_hours, projects_array
  end

  def group_by_person(data,crosscutting)

    results = {}
    cost_shared_hours = Hash.new(0)
    (data || []).each do |record|
      if crosscutting.include? record.project_id
        cost_shared_hours[record.employee_id] +=  record.duration
      else
        if results[record.employee_id].blank?
          results[record.employee_id] = {record.project_id => record.duration}
        else
          results[record.employee_id][record.project_id]  = record.duration
        end
      end
    end

    return results, cost_shared_hours
  end

  def petty_cash_report_pdf(petty_cash_data, start_day, end_day)
    Prawn::Document.generate('tmp/petty_cash_report.pdf', page_size: 'A4', page_layout: :portrait, left_margin: 40, right_margin: 30) do |pdf|
      pdf.image "app/assets/images/GHII-Letterhead.png", width: 550, height: 80
      pdf.move_down 20

      pdf.font_size 10
      pdf.text "<b>Petty Cash Report</b>", align: :center, inline_format: true
      pdf.move_down 10

      pdf.font_size 10
      pdf.text "<b>Period:</b> #{start_day} - #{end_day}", inline_format: true
      pdf.move_down 10

      table_data = [['#', 'Date Requested', 'Requester', 'Description', 'Project', 'Amount Requested', 'Status']]

      petty_cash_data.each_with_index do |requisition, index|
        row = [
          index + 1,
          requisition.initiated_on.strftime('%d-%m-%Y'),
          requisition.user.full_name,
          requisition.purpose,
          requisition.project.short_name,
          requisition.amount,
          requisition.workflow_state.state
        ]
        table_data << row
      end

      pdf.table(table_data, header: true, cell_style: { size: 8 }, width: pdf.bounds.width) do
        row(0).font_style = :bold
        row(0).background_color = 'dddddd'
        columns(0..6).align = :center
      end

      pdf.move_down 50
      pdf.text "Generated By: #{Prawn::Text::NBSP*1}#{current_user.full_name} #{Prawn::Text::NBSP*100}Date: #{Time.now.strftime('%d-%m-%Y')}"
      pdf.move_down 30
      pdf.text "Signature:  #{Prawn::Text::NBSP*1}________________________________________"
    end
  end

  def petty_cash_report_xls(petty_cash_data, start_day, end_day)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet(name: 'Petty Cash Report')

    sheet.row(0).push("Petty Cash Report")
    sheet.row(1).push("Period: #{start_day} - #{end_day}")
    sheet.row(2).push("")

    sheet.row(3).push('#', 'Date Requested', 'Requester', 'Description', 'Project', 'Amount Requested', 'Status')

    petty_cash_data.each_with_index do |requisition, index|
      row_index = index + 4
      sheet.row(row_index).push(
        index + 1,
        requisition.initiated_on.strftime('%d-%m-%Y'),
        requisition.user.full_name,
        requisition.purpose,
        requisition.project.short_name,
        requisition.amount,
        requisition.workflow_state.state
      )
    end

    sheet.row(petty_cash_data.size + 5).push("Generated By: #{current_user.full_name}")
    sheet.row(petty_cash_data.size + 6).push("Date: #{Time.now.strftime('%d-%m-%Y')}")
    sheet.row(petty_cash_data.size + 7).push("Signature: __________________________________")

    book.write 'tmp/petty_cash_report.xls'
  end

  def leave_request_report_xls(leave_data)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet(name: 'Leave Request Report')

    sheet.row(0).concat ['Employee Name', 'Annual Taken', 'Annual Balance', 'Compassionate Taken', 'Compassionate Balance', 'Sick Taken', 'Sick Balance']

    leave_data.each_with_index do |list, index|
      row = index + 1
      sheet.row(row).push(
        list[1],
        @leave_taken[list[0]][@leave_proj_ids[0]] || 0,
        @leave_balances[list[0]]['Annual Leave'] ,
        @leave_taken[list[0]][@leave_proj_ids[1]] || 0,
        @leave_balances[list[0]]['Compassionate Leave'] ,
        @leave_taken[list[0]][@leave_proj_ids[2]] || 0,
        @leave_balances[list[0]]['Sick Leave']
        )
    end

    book.write 'tmp/leave_request_report.xls'
  end

  def leave_request_report_pdf(leave_data)
    Prawn::Document.generate('tmp/leave_request_report.pdf', page_size: 'A4', page_layout: :landscape) do |pdf|
      pdf.image "app/assets/images/GHII-Letterhead.png", width: 550, height: 80
      pdf.move_down 20

      pdf.font_size 12
      pdf.text "<b>Leave Request Report</b>", align: :center, inline_format: true
      pdf.move_down 10

      table_data = [
        ['Employee Name', 'Annual Taken', 'Annual Balance', 'Compassionate Taken', 'Compassionate Balance', 'Sick Taken', 'Sick Balance']
      ]

      leave_data.each do |list|
        row = [
          list[1],
          @leave_taken[list[0]][@leave_proj_ids[0]] || 0,
          @leave_balances[list[0]]['Annual Leave'] ,
          @leave_taken[list[0]][@leave_proj_ids[1]] || 0,
          @leave_balances[list[0]]['Compassionate Leave'],
          @leave_taken[list[0]][@leave_proj_ids[2]].blank? ? '-' : @leave_taken[list[0]][@leave_proj_ids[2]],
          @leave_balances[list[0]]['Sick Leave']
        ]
        table_data << row
      end

      pdf.table(table_data, header: true, cell_style: { size: 9 }, width: pdf.bounds.width) do
        row(0).font_style = :bold
        row(0).background_color = 'dddddd'
        columns(0..6).align = :center
      end

      pdf.move_down 40
      pdf.text "Generated By: #{Prawn::Text::NBSP*1}#{current_user.full_name} #{Prawn::Text::NBSP*100}Date: #{Time.now.strftime('%d-%m-%Y')}"
      pdf.move_down 20
      pdf.text "Signature:  #{Prawn::Text::NBSP*1}________________________________________"
    end
  end


end

require 'csv'
def main
  # frozen_string_literal: true

  CSV.foreach("#{Rails.root}/db/GHII-Seed/GHII_Timesheet_Raw.csv",:headers=>:true) do |row|
    puts "#{row[0].split( " ")[0].strip} #{row[0].split( " ")[1].strip} #{row[1]} #{row[3]}"
    employee = Person.where(first_name: row[0].split( " ")[0].strip.titlecase,
                            last_name: row[0].split( " ")[1].strip.titlecase).first.employee

    day = fix_date(row[1])

    timesheet = Timesheet.where(employee_id: employee.id, submitted_on: fix_date(row[2]),
                                timesheet_week: day.beginning_of_week).first_or_create

    (0..6).each do |col|
      next if (row[col+5].nil? || row[col+5] == 0)
      prj = Project.where("(short_name = '#{row[3]}') OR (project_name = '#{row[3]}')").first.id

      TimesheetTask.create(task_date: day.advance(:days => col),project_id: prj ,
                           timesheet_id: timesheet.id, description: row[4], duration: row[col+5])
    end
  end

=begin

  CSV.foreach("#{Rails.root}/db/GHII-Seed/timesheet_data.csv",:headers=>:true) do |row|
    employee = Person.where(first_name: row[1].split( " ")[0].strip,
                            last_name: row[1].split( " ")[1].strip).first.employee

    day = Date.parse(row[0])
    timesheet = Timesheet.where(employee_id: employee.id, timesheet_week: day.advance(:days => (1-day.cwday))).first_or_create

    TimesheetTask.create(task_date: row[0],project_id: Project.where(short_name: row[2]).first.id,
                         timesheet_id: timesheet.id, description: row[3], duration: row[4])
  end
=end
end

def fix_date(day)
  return Date.parse(day)
end

main


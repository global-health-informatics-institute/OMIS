require 'csv'


source = "#{Rails.root}/db/data/#{ENV['data'] || 'demo'}"
puts "Seeding the database with #{ENV['data']} data"


puts "Adding Branches"
CSV.foreach("#{source}/branches.csv",:headers=>:true) do |row|
  Branch.create(branch_name: row[0], city: row[2], country: row[1], location: row[3])
end

puts "Adding Departments"
CSV.foreach("#{source}/departments.csv",:headers=>:true) do |row|
  branch = Branch.find_by_branch_name(row[0])
  Department.create(branch_id: branch.id, department_name: row[1])
end

puts "Adding Designations"
CSV.foreach("#{source}/designations.csv",:headers=>:true) do |row|
  department = Department.joins(:branch).where('branches.branch_name' => row[0],
                                               department_name: row[1]).first

  Designation.create(department_id: department.id, designated_role: row[2])
end

puts "Adding people"

CSV.foreach("#{source}/employees.csv",:headers=>:true) do |row|
  new_person = Person.create(first_name: row[0],
                             middle_name: row[1],
                             last_name: row[2],
                             birth_date: row[3],
                             gender: row[4],
                             marital_status: row[5],
                             primary_phone: row[6],
                             alt_phone: row[7],
                             email_address: row[8],
                             official_email: row[9],
                             postal_address: row[10],
                             residential_address: row[11],
                             landmark: row[12])

  new_employee = Employee.create(person_id: new_person.id, employment_date: row[13], departure_date: row[14],
                                 still_employed: (row[14].blank? ? true : false))

  User.create(employee_id: new_employee.id, activated_at: new_employee.employment_date, activated: true,
              username: "#{new_person.last_name}#{new_person.first_name[0]}#{rand(100).to_s.rjust(3,"0")}",
              password: "#{new_person.last_name}#{new_person.first_name[0]}")
end

puts "Adding employee designations"
CSV.foreach("#{source}/employee_designations.csv", :headers => :true) do |row|
  employee = Person.where(first_name: row[0].strip, last_name:row[2].strip,
                          middle_name: (row[1].blank? ? nil : row[1])).first.employee
  dept = Department.select(:department_id).joins(:branch).where("branches.branch_name": row[3]).collect{|x| x.id}
  designation = Designation.where(department_id: dept, designated_role: row[4]).first
  EmployeeDesignation.create(employee_id: employee.id,
                             designation_id: designation.id,
                             start_date: row[5],
                             end_date: (row[6].blank? ? nil : row[6]))
end


puts "Adding supervision"
CSV.foreach("#{source}/supervision.csv", :headers => :true) do |row|

  supervisor = Person.where(first_name: row[3].strip.split(" ")[0],
                            last_name:row[3].strip.split(" ").last,
                            middle_name: (row[3].strip.split(" ").length == 3 ? row[3].strip.split(" ")[1] : nil)).first.employee

  supervisee = Person.where(first_name: row[0].strip, last_name:row[2].strip,
                          middle_name: (row[1].blank? ? nil : row[1])).first.employee

  Supervision.create(supervisor: supervisor.id, supervisee: supervisee.id,
              started_on: row[4], ended_on: (row[5].blank? ? nil : row[5]),
              is_terminated: (row[5].blank? ? false : true))

end

puts "Adding projects"
CSV.foreach("#{source}/projects.csv", :headers => :true) do |row|
  manager = Person.where(first_name: row[2].split(" ")[0].strip, last_name: row[2].split(" ")[1].strip).first
  Project.create(project_name: row[0], short_name: row[3], project_description: row[1],
                 manager: manager.employee.id, created_at: row[5], completed_at: (row[4].blank? ? nil : row[4]))
end

puts "Adding loe"
CSV.foreach("#{source}/loe.csv", :headers => :true) do |row|
  employee = Person.where(first_name: row[0].strip, last_name:row[2].strip,
                            middle_name: (row[1].blank? ? nil : row[1])).first.employee

  ProjectTeam.create(employee_id: employee.id,  allocated_effort: (row[4].to_f), start_date: row[5],
                     end_date: (row[6].blank? ? nil : row[6]),
                     project_id: Project.where("(short_name = '#{row[3].squish}') OR (project_name = '#{row[3].squish}')").first.id
                     )
end

puts "Adding time sheets"

CSV.foreach("#{source}/timesheets.csv",:headers=>:true) do |row|

  employee = Person.where(first_name: row[0].split( " ").first.strip.titlecase,
                          last_name: row[0].split( " ").last.strip.titlecase).first.employee

  day = Date.parse(row[1])

  timesheet = Timesheet.where(employee_id: employee.id, submitted_on: Date.parse(row[2]),
                              timesheet_week: day.beginning_of_week).first_or_create

  (0..6).each do |col|
    next if (row[col+5].nil? || row[col+5].to_f == 0.0)
    prj = Project.where("(short_name = '#{row[3].squish}') OR (project_name = '#{row[3].squish}')").first.id

    TimesheetTask.create(task_date: day.beginning_of_week.advance(:days => col),project_id: prj ,
                         timesheet_id: timesheet.id, description: row[4], duration: row[col+5])
  end
end

puts "Adding Asset Categories"

CSV.foreach("#{source}/asset_categories.csv",:headers=>:true) do |row|
  AssetCategory.create(category: row[0], description: row[1])
end

puts "Adding Assets"

CSV.foreach("#{source}/assets.csv",:headers=>:true) do |row|
  Asset.create(tag_id: row[1] , description: row[2], make: row[3], model: row[4],
               serial_number: row[5], location: row[6], value: row[7],status: row[8],
               asset_category_id: AssetCategory.find_by_category(row[0]).id)
end

=begin
puts "Adding project management data"
CSV.foreach("#{source}/project_data.csv", headers: true) do |row|

  ProjectTask.create({
                       project_id: project.id,
                       task_description: row[1],
                       created_at: row[2],
                       deadline: Date.strptime(row[3], '%m/%d/%Y'),
                       #estimated_duration: (Date.strptime(row[3], '%m/%d/%Y') - row[2])
                     })
end
=end
puts "Seeding database done"


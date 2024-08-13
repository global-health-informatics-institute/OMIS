require 'csv'


source = "#{Rails.root}/db/data/#{ENV['data'] || 'demo'}"
puts "Seeding the database with #{ENV['data']} data"


puts 'Adding Branches'
CSV.foreach("#{source}/branches.csv",:headers=>:true) do |row|
  Branch.create(branch_name: row[0], city: row[2], country: row[1], location: row[3])
end

puts 'Adding Departments'
CSV.foreach("#{source}/departments.csv",:headers=>:true) do |row|
  branch = Branch.find_by_branch_name(row[0])
  Department.create(branch_id: branch.id, department_name: row[1])
end

puts 'Adding Designations'
CSV.foreach("#{source}/designations.csv",:headers=>:true) do |row|
  department = Department.joins(:branch).where('branches.branch_name' => row[0],
                                               department_name: row[1]).first

  Designation.create(department_id: department.id, designated_role: row[2])
end

puts 'Adding people'

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

puts 'Adding employee designations'
CSV.foreach("#{source}/employee_designations.csv", :headers => :true) do |row|
  employee = Person.where(first_name: row[0].strip, last_name:row[2].strip,
                          middle_name: (row[1].blank? ? nil : row[1])).first.employee
  dept = Department.select('department_id').joins(:branch).where("branches.branch_name": row[3]).collect{ |x| x.id }
  designation = Designation.where(department_id: dept, designated_role: row[4]).first
  EmployeeDesignation.create(employee_id: employee.id,
                             designation_id: designation.id,
                             start_date: row[5],
                             end_date: (row[6].blank? ? nil : row[6]))
  Affiliation.create(employee_id: employee.id, department_id: designation.department_id, started_on: row[5],
                     ended_on: (row[6].blank? ? nil : row[6]), is_terminated: (row[6].blank? ? false : true))
end


puts 'Adding supervision'
CSV.foreach("#{source}/supervision.csv", :headers => :true) do |row|

  supervisor = Person.where(first_name: row[3].strip.split(' ')[0],
                            last_name:row[3].strip.split(' ').last,
                            middle_name: (row[3].strip.split(' ').length == 3 ? row[3].strip.split(' ')[1] : nil)).first.employee

  supervisee = Person.where(first_name: row[0].strip, last_name:row[2].strip,
                          middle_name: (row[1].blank? ? nil : row[1])).first.employee

  Supervision.create(supervisor: supervisor.id, supervisee: supervisee.id,
              started_on: row[4], ended_on: (row[5].blank? ? nil : row[5]),
              is_terminated: (row[5].blank? ? false : true))

end

puts 'Adding projects'
CSV.foreach("#{source}/projects.csv", :headers => :true) do |row|
  manager = Person.where(first_name: row[2].split(' ')[0].strip, last_name: row[2].split(' ')[1].strip).first
  Project.create(project_name: row[0], short_name: row[3], project_description: row[1],
                 manager: manager.employee.id, created_at: row[5], completed_at: (row[4].blank? ? nil : row[4]))
end

puts 'Adding loe'
CSV.foreach("#{source}/loe.csv", :headers => :true) do |row|
  employee = Person.where(first_name: row[0].strip, last_name:row[2].strip,
                            middle_name: (row[1].blank? ? nil : row[1])).first.employee

  ProjectTeam.create(employee_id: employee.id,  allocated_effort: (row[4].to_f), start_date: row[5],
                     end_date: (row[6].blank? ? nil : row[6]),
                     project_id: Project.where("(short_name = '#{row[3].squish}') OR (project_name = '#{row[3].squish}')").first.id
                     )
end

puts 'Adding time sheets'

CSV.foreach("#{source}/timesheets.csv",:headers=>:true) do |row|

  employee = Person.where(first_name: row[0].split( ' ').first.strip.titlecase,
                          last_name: row[0].split( ' ').last.strip.titlecase).first.employee

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

puts 'Adding Asset Categories'

CSV.foreach("#{source}/asset_categories.csv",:headers=>:true) do |row|
  AssetCategory.create(category: row[0], description: row[1])
end

puts 'Adding Assets'

CSV.foreach("#{source}/assets.csv",:headers=>:true) do |row|
  Asset.create(tag_id: row[1] , description: row[2], make: row[3], model: row[4],
               serial_number: row[5], location: row[6], value: row[7],status: row[8],
               asset_category_id: AssetCategory.find_by_category(row[0]).id)
end

puts 'Adding Workflows and States'
CSV.foreach("#{source}/workflow_processes.csv",:headers=>:true) do |row|
  wp = WorkflowProcess.where(workflow: row[0]).first_or_create
  wfs = WorkflowState.where(workflow_process_id: wp.id, state: row[1], description: row[2]).first_or_create

  if row[3].upcase.strip == 'TRUE'
    puts "Adding initial state"
    InitialState.create(workflow_process_id: wp.id, workflow_state_id: wfs.id)
  end
end

puts 'Adding workflow transitions'
CSV.foreach("#{source}/workflow_state_transitions.csv",:headers=>:true) do |row|
  wp = WorkflowProcess.where(workflow: row[0]).first_or_create
  wps_1 = WorkflowState.where(workflow_process_id: wp.id, state: row[1]).first_or_create
  wps_2 = WorkflowState.where(workflow_process_id: wp.id, state: row[2]).first_or_create
  wft = WorkflowStateTransition.where(workflow_state_id: wps_1, next_state: wps_2, action:row[3],
                                by_owner: (row[4].upcase == "TRUE" ? true : false),
                                by_supervisor: (row[5].upcase == "TRUE" ? true : false),
                                ).first_or_create

 (row[6].split(';')).each do |transitioner|
   WorkflowStateActor.create(workflow_state_transition: wft.id,
                          employee_designation_id: Designation.find_by_designated_role(transitioner).id)
 end
end

puts 'Seeding database done'

GlobalProperty.create(property: 'number.of.hours', property_value:'7.5', description: 'Number of hours ' )
GlobalProperty.create(property: 'month.start.date', property_value:'25', description: 'Number of hours ' )
GlobalProperty.create(property: 'full.time.annual.leave', property_value:'1.75',
                      description: 'Number of leave days per month' )
GlobalProperty.create(property: 'part.time.annual.leave', property_value:'1.25',
                      description: 'leave days for part time employee' )
GlobalProperty.create(property: 'petty.cash.limit', property_value:'40000',
                      description: 'Amount that can be transacted using petty cash' )
GlobalProperty.create(property: 'per.diem.lunch', property_value:'6000',
                      description: 'Allocated amount for lunch allowance' )
GlobalProperty.create(property: 'per.diem.dinner', property_value:'8000',
                      description: 'Allocated amount for dinner allowance' )
GlobalProperty.create(property: 'per.diem.incidental', property_value:'1.25',
                      description: 'Allocated amount for incidental allowance' )
GlobalProperty.create(property: 'per.diem.accommodation', property_value:'30000',
                      description: 'Allocated amount for accommodation' )
=begin
wp = WorkflowProcess.create(workflow: 'Timesheet')
WorkflowState.create(workflow_process_id: wp.id, state: 'Pending Submission',
                     description: 'State where the timesheet is open for editing by the user')
WorkflowState.create(workflow_process_id: wp.id, state: 'Submitted',
                     description: 'State where the timesheet has been submitted by the employee to the supervisor for review')
WorkflowState.create(workflow_process_id: wp.id, state: 'Recalled',
                     description: 'State where the timesheet was previously submitted by the employee to the supervisor for review but the employee requested the timesheet to be re-opened for editing')
WorkflowState.create(workflow_process_id: wp.id, state: 'Rejected',
                     description: 'State where a submitted timesheet has been sent back by the supervisor for the employee to fix something')
WorkflowState.create(workflow_process_id: wp.id, state: 'Approved',
                     description: 'State where a submitted timesheet has been cleared by the supervisor')
WorkflowState.create(workflow_process_id: wp.id, state: 'Re-opened',
                     description: 'State where a previously approved timesheet is made available for editing by the supervisor or designated official')
WorkflowState.create(workflow_process_id: wp.id, state: 'Re-submitted',
                     description: 'State where a timesheet has been resubmitted and has to be approves by the supervisor or designated official')


WorkflowStateTransition.create(workflow_state_id: 1, next_state: 2, action:'Submit', by_owner: true)
WorkflowStateTransition.create(workflow_state_id: 2, next_state: 3, action:'Recall Timesheet', by_owner: true)
WorkflowStateTransition.create(workflow_state_id: 2, next_state: 4, action:'Reject Timesheet')
WorkflowStateTransition.create(workflow_state_id: 2, next_state: 5, action:'Approve Timesheet')
WorkflowStateTransition.create(workflow_state_id: 3, next_state: 7, action:'Re-submit Timesheet', by_owner: true)
WorkflowStateTransition.create(workflow_state_id: 4, next_state: 7, action:'Re-submit Timesheet', by_owner: true)
WorkflowStateTransition.create(workflow_state_id: 5, next_state: 6, action:'Re-open Timesheet')
WorkflowStateTransition.create(workflow_state_id: 6, next_state: 7, action:'Re-submit Timesheet', by_owner: true)
WorkflowStateTransition.create(workflow_state_id: 7, next_state: 5, action:'Approve Timesheet')
=end

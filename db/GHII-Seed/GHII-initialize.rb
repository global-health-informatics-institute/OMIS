require 'csv'

def main
  # Initialize Branches and Departments
  add_branch_departments

  # Initialize People
  initialize_hr

  # Initialize Supervision
  set_supervision_roles

  # Initialize Projects
  initialize_projects

  # Initialize Projects
  initialize_project_loe

  # Initialize Assets
  initialize_assets

end

def add_branch_departments
  puts "Adding new branches"
  branch = Branch.create(branch_name: 'Training Center - HQ',country: 'Malawi',city: 'Lilongwe',location: 'Area 3')
  ['Finance & Administration', 'Programs','Research & Evaluation', 'Training Program'].each do |department|
    # Initialize Departments and Roles
    dept = Department.create(branch_id: branch.id, department_name: department)
    add_designations(dept.id, dept.department_name)
  end
end

def add_designations(dept_id, dept_name)
  dept_roles = {'Finance & Administration' => ['Finance & Administration Lead', 'Finance Officer','Artisan',
                                             'Administrative Officer', 'Human Resource Officer','Driver',
                                             'Industrial Attache', 'Human Resources & Administrative Officer',
                                             'Director','Operations Officer'],
                'Programs'=>['Program Officer', 'Program Manager', 'Programs Lead', 'Technician','Team Leader',
                            'Technician Assistant', 'Engineering Intern', 'Applications Development Intern',
                            'Informatics Intern', 'Jnr Applications Developer', 'Applications Developer',
                             'Engineering Volunteer','Industrial Attache', 'Senior Applications Developer',
                             'Data Access Center Lead', 'Systems Architecture Lead', 'Data Analyst',
                             'Program Specialist', 'Software Engineer', 'Oxygen Alliance Technician'],
                'Research & Evaluation'=>['Research & Evaluation Lead','Product Owner', 'Product Development Manager',
                                         'M & E Manager','Mechanical Engineering Intern','Product Developer' ,
                                          'M & E Officer', 'Research Assistant', 'CAD/CAM Engineer'],
                'Training Program'=>['Training Faculty', 'Training Program Lead']}

  puts "Adding new designations for #{dept_name}"

  (dept_roles[dept_name] || []).each do |desig|
    puts "Adding #{desig} as new designation"
    Designation.create(department_id: dept_id, designated_role: desig)
  end
end

def initialize_hr
  CSV.foreach("#{Rails.root}/db/GHII-Seed/GHII_HR_Data_Final.csv",:headers=>:true) do |row|
    puts "Adding new person"
    new_person = Person.new(
      first_name: row[1].strip,
      middle_name: row[2].nil? ? nil : row[2].strip,
      last_name: row[3].strip,
      birth_date: row[4].strip,
      gender: row[5].strip,
      marital_status: row[10].strip,
      official_email: "#{row[1].strip}.#{row[3].strip}@ghii.org"
    )
    if new_person.save
      add_employee(new_person, row[7], row[6],row[11])
    end
  end
end

def add_employee(person, employment_date, raw_designation, departure_date)
  puts "Adding new employees"
    new_employee = Employee.create(person_id: person.id, employment_date: employment_date,
                                   departure_date: (departure_date.nil? ? nil : departure_date))
    add_user(new_employee, "#{person.last_name}#{person.first_name[0]}#{rand(100).to_s.rjust(3,"0")}")

  puts(raw_designation)
  designation = Designation.find_by_designated_role(raw_designation)

  EmployeeDesignation.create(employee_id: new_employee.id, designation_id: designation.id,
                               start_date: new_employee.employment_date
    )
  Affiliation.create(employee_id: new_employee.id, department_id: designation.department_id,
                       started_on: new_employee.employment_date)
end

def add_user(employee, username)
  puts "Adding new users"
  user = User.new({employee_id: employee.id, username: username, password: username,
                     activated_at: employee.employment_date, reset_needed: true,
                   activated: true})
  user.save
end


def set_supervision_roles
  puts "Loading Supervision Roles"
  CSV.foreach("#{Rails.root}/db/GHII-Seed/GHII_HR_Data_Final.csv",:headers=>:true) do |row|
    next if row[9] == nil
    supervisor = Person.find_by_last_name(row[9].strip)
    supervisee = Person.where(first_name: row[1].strip, last_name: row[3].strip).first
    Supervision.create(supervisor: supervisor.employee.id, supervisee: supervisee.employee.id)
  end
end

def initialize_projects
  CSV.foreach("#{Rails.root}/db/GHII-Seed/projects.csv",:headers=>:true) do |row|
    puts row[2]
    manager = Person.where(first_name: row[2].split(" ")[0].strip,
                          last_name: row[2].split(" ")[1].strip).first
    Project.create(project_name: row[0], short_name: row[4], project_description: row[1],
                   manager: manager.id)
  end
end


def initialize_assets

  puts "Adding Assets"
  categories = {"Heavy Machinery": "Stationary devices used to perform or facilitate manual or mechanical work", 
    "Tools": "Any portable implement used to perform or facilitate manual or mechanical work", 
    "Electronic Device": "A digital implement designed to execute specific tasks", 
    "Motor Vehicles": "Any self-propelled means of transportaion that does not run on rails", 
    "Furniture": "Movable objects intended to support activities  such as seating, eating, storing items, working, and sleeping."}

  categories.each do |k,v|
    AssetCategory.create(category: k, description: v)
  end

  CSV.foreach("#{Rails.root}/db/GHII-Seed/ghii_assets.csv",:headers=>:true) do |row|
    Asset.create(tag_id: row[6] , description: row[0], make: row[1], model: row[2],
                 serial_number: row[3], location: row[5], value: row[4],status: "Current",
                 asset_category_id: AssetCategory.find_by_category(row[7]).id)
  end
end

def initialize_project_loe
  headers = CSV.foreach("#{Rails.root}/db/GHII-Seed/project_loe.csv").first

  CSV.foreach("#{Rails.root}/db/GHII-Seed/project_loe.csv",:headers=>:true) do |row|

    person = Person.where(first_name: row[0].split(" ")[0].strip,
                           last_name: row[0].split(" ")[1].strip).first
    puts row[0]
    (1..(headers.length-1)).each do |i|
      if !row[i].blank?
        project = Project.find_by_project_name(headers[i])
        ProjectTeam.create(project_id: project.project_id, employee_id: person.employee.employee_id, allocated_effort: row[i] )
      end
    end

  end
end

main

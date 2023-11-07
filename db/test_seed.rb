
DEPARTMENTS = {
    "HQ": {'Human Resources': [{posts: 1, role: 'Human Resource Officer'},{posts: 2, role:'Human Resource Intern'},
                               {posts: 1, role:'Human Resource Manager'}],
        'Finance': [{posts: 1, role:'Debt Collector'}, {posts: 2, role:'Accountant'},
                    {posts: 1, role: 'Senior Accountant'}, {posts: 1, role:'Procurement Specialist'}],
        'Administration': [{posts: 2, role:'Operations Officer'}, {posts: 1, role:'Operations Manager'},
                           {posts: 3, role:'Driver'}],
        'Software Development': [{posts: 3, role:'Software Developer'}, {posts: 1, role:'Snr Software Developer'},
                                 {posts: 5, role:'Jnr Software Developer'}],
        'Support & Deployment': [{posts: 2, role:'Network Engineer'}, {posts: 2, role:'Power Engineer'},
                                 {posts: 4, role:'Support Officer'}, {posts: 2, role:'Deployment Officer'},
                                 {posts: 2, role:'Training Officer'}]
    }}

PROJECTS = ['Stellar Sparks','Dreamweaver Labs','Fusion Forge','Vibrant Visions','TechnoTrailblazers',
            'Blissful Beginnings','Innovation Junction','Harmony Haven','Mosaic Masterminds','Creativity Catalyst',
            'Beyond Boundaries','Conceptual Canvas','Imagine Impact','Kaleidoscope Ventures','Zenith Innovations',
            'Stellar Skies','Eureka Express','Pinnacle Projects','Chromatic Creations','Infinitum Ideas',
            'Luminescent Labs','Fusion Foundry','Inventive Insights','Sparkstorm Studios','Mystical Makers',
            'Oasis of Inspiration','Resonance Realm','Trailblazer Technologies',
            'Palette Playground','Visionary Ventures','Sick Leave','Annual Leave', 'Compassionate Leave']

supervision = [["Human Resource Officer","Human Resource Manager"],
               ["Human Resource Intern","Human Resource Manager"] ,
               ["Debt Collector","Senior Accountant"],
               ["Accountant","Senior Accountant"],
               ["Procurement Specialist","Operations Manager"] ,
               ["Operations Officer","Operations Manager"],
               ["Driver", "Human Resource Manager"],
                ["Software Developer","Snr Software Developer"],
                ["Snr Software Developer","Operations Manager"],
                ["Jnr Software Developer","Snr Software Developer"],
                ["Network Engineer","Operations Manager"],
                ["Power Engineer","Operations Manager"],
                ["Support Officer","Operations Manager"],
                ["Deployment Officer","Operations Manager"],
                ["Training Officer""Operations Manager"]
]

def main
    add_branch()
    add_projects()
    add_timesheets()
end

def add_branch
    puts "Adding new branches"
    Branch.create([{branch_name: 'HQ',country: 'Malawi',city: 'Lilongwe',location: 'Area 3'},
         {branch_name: 'Blantyre Branch',country: 'Malawi',city: 'Blantyre', location: 'Mandala'}])
    DEPARTMENTS.each do |branch, departments|
        add_departments(branch, departments)
    end
end
    
def add_departments(branch, departments)
    puts "Adding new departments"
    branch_obj = Branch.find_by_branch_name(branch)
    departments.each do |dept, roles|
        dept = Department.create(branch_id: branch_obj.id, department_name: dept)
        add_designations(dept, roles)
    end
end

def add_designations(department, roles)
    puts "Adding new designations"
    (roles || []).each do |desig|
        new_designation = Designation.create(department_id: department.id, designated_role: desig[:role])
        add_employee(desig[:posts], new_designation)
    end
end

def add_person
    puts "Adding new person"
    new_person = Person.new(
      first_name: random_first_name,
      middle_name: random_first_name,
      last_name: random_last_name,
      birth_date: Date.today().advance(years: -(18+Random.rand(30))),
      gender: %w[Male Female Other].sample,
      marital_status: %w[Single Married Divorced Other].sample,
      primary_phone: "#{+265} #{%w[99 88].sample} #{Random.rand(9999999)}",
      alt_phone: "#{+265} #{%w[99 88].sample} #{Random.rand(9999999)}",
      postal_address: "",
      residential_address: "",
      landmark: ""
    )
    new_person.email_address ="#{new_person.first_name}.#{new_person.last_name}@email.org"
    new_person.save
    return new_person
end

def add_employee(count, designation)
    puts "Adding new employees"
    count.times do
        person = add_person
        new_employee = Employee.create(person_id: person.id, employment_date: Date.today().advance(days: -Random.rand(1000)))
        add_user(new_employee, "#{person.last_name}#{person.first_name[0]}")
        EmployeeDesignation.create(employee_id: new_employee.id, designation_id: designation.id,
                                              start_date: new_employee.employment_date
        )
        Affiliation.create(employee_id: new_employee.id, department_id: designation.department_id,
                           started_on: new_employee.employment_date)
    end
end

def add_user(employee, username)
    puts "Adding new users"
    user = User.create(employee_id: employee.id, username: username, password: username,
                       activated_at: employee.employment_date, activated: true )
end

def add_supervision

end


def add_projects
    puts "Adding projects"
    (PROJECTS || []).each do |project|
        Project.create(project_name: project, short_name: project, project_description: project, manager: Person.first.id)
    end
end

def random_first_name
    names = ['Harry','Jeremiah','Alfonso','Marion','Douglas','Johnnie','Darlene','Estefana','Lewis','Maurine',
             'Jaleesa','Moises','Trinh','Eliza','Feli','Kassandra','Olene','Lahoma','Anjelica','Ehtel','Tanisha',
             'Willette', "Abigail","Alexandra","Alison","Amanda","Amelia","Amy","Andrea", "Bella","Bernadette","Carol",
             "Caroline","Carolyn","Chloe","Claire", "Dorothy","Elizabeth","Ella","Emily","Emma","Faith","Felicity",
             "Natalie","Nicola","Olivia","Penelope","Pippa","Rachel","Rebecca","Sonia","Sophie","Stephanie","Sue",
             "Theresa","Tracey","Una","Vanessa", "Adrian","Alan","Alexander","Andrew","Anthony","Austin","Benjamin",
             "Cameron","Carl","Charles","Christian","Christopher","Colin","Connor" "Edward","Eric","Evan","Frank",
             "Gavin","Gordon","Harry", "Denise", "Fidelia","Vanetta","Julie","Mary","Sherie","Keisha","Piedad", "Dina"]

      return names[rand(names.length)]
end

def random_last_name
    names = ["Ball","Bell","Berry","Black","Blake","Bond","Bower","Brown","Buckland","Burgess","Butler","Cameron",
             "Campbell","Carr","Chapman","Churchill","Clark","Clarkson","Coleman","Cornish","Davidson","Davies",
             "Dickens","Dowd","Duncan","Dyer","Edmunds","Ellison","Ferguson","Fisher","Forsyth","Fraser","Gibson",
             "Gill","Glover","Graham","Grant","Gray","Greene","Hamilton","Hardacre","Harris","Hart","Hemmings",
             "Henderson","Hill","Hodges","Howard","Hudson","Hughes","Hunter","Ince","Jackson","James","Johnston","Jones",
             "Kelly","Kerr","King","Knox","Lambert","Langdon","Lawrence","Lee","Lewis","Lyman","MacDonald","Mackay",
             "Mackenzie","MacLeod","Manning","Marshall","Martin","Mathis","May","McDonald","McLean","McGrath",'Gulley',
             'Conn','Ledbetter','Christiansen','Morrow','Suggs','Burris','Mortensen','Mccffrey','Bethel',
             'Bullard','Fallon','Winkler','Hoff','Dabney','Swain','Osburn','Truit','Hook','Trotter','Douglas','Bennett',
             "WESTBAY","WEPPLER","WAMBOLDT","WALDROOP","VONDRASEK","VLAHAKIS","VINSANT","VANO","VANDERWEELE","TUFARO",
             "TUCKERMAN","TRUEHEART","TRETTIN","STAVISH","STARIN","SOOKRAM","SONNENFEL",
             'Lambert','Hopkins','Blair','Black','Norman','Gomez','Shelton','Martin']

    return names[rand(names.length)]

end

def random_projects

    return PROJECTS[Random.rand(PROJECTS.length)]
end

def randomize_leave

    leave_type = ['Sick Leave','Annual Leave', 'Compassionate Leave']
    days = 10*Random.rand().floor(1)

    return leave_type[Random.rand(leave_type.length)]
end

def randomize_timesheets(employee)

    end_date = employee.departure_date.blank? ? Date.today : employee.departure_date

    (0..(end_date - employee.employment_date).to_i).each do |day|
        work_day = employee.employment_date.advance(:days => day)
        next if (work_day.cwday == 0  || work_day.cwday == 6)
        is_leave = Random.rand()
        if is_leave >=0.75 and is_leave <= 0.82
            prj = Project.where("(project_name = '#{randomize_leave}')").first.id
            timesheet = Timesheet.where(employee_id: employee.id,
                                        timesheet_week: work_day.beginning_of_week).first_or_create
            TimesheetTask.create(task_date: work_day,
                                 project_id: prj , timesheet_id: timesheet.id,
                                 description: "On leave",
                                 duration: 8)
        else
            duration = 0.0
            until duration >= 8.0
                task_length = Random.rand(1..32).floor(2)*0.25
                prj = Project.where("(project_name = '#{random_projects}')").first.id
                timesheet = Timesheet.where(employee_id: employee.id,
                                            timesheet_week: work_day.beginning_of_week).first_or_create
                TimesheetTask.create(task_date: work_day,
                                     project_id: prj , timesheet_id: timesheet.id,
                                     description: random_tasks(employee.current_position),
                                     duration: task_length)
                duration += task_length
            end
        end
    end
end

def add_timesheets
    employees = Employee.all
    (employees || []).each do |employee|
        randomize_timesheets(employee)
    end
end

def random_tasks(role)

    puts role
    tasks =  {'Human Resource Officer'=> ['Maintaininig employee records','Developing training program', 'Onboarding planning',
                                'Onboarding of new staff','Preparing JDs','Postings job ads', 'Providing counsel',
                                'Coordinating training sessions'],
     'Human Resource Intern'=> ['Postings job ads','Maintaininig employee records','Schedule meetings',
                               'Schedule interviews','Schedule HR events','Maintain calendars of the HR management team'],
     'Human Resource Manager'=> ['Developing and implementing human resources policies','Supporting strategic objectives',
             'negotiating employment agreements', 'Managing staff wellness', 'Performance reviews',
             'Motivating and supporting current staff', 'Maintaining staff records', 'Handling employee benefits',
             'Identifying staffing needs and creating job descriptions','Onboarding of new staff'],
     'Debt Collector'=> ['Identifying deviations from predetermined payment plans',
                        'Emailing defaulters to restate their dues.',
                        'Calling defaulters to restate their dues.', 'Locating fugitive defaulters ',
                        'Proposing realistic, carefully-constructed payment plans.',
                        'Negotiating newly-adjusted payment plans.'
     ],
     'Accountant'=> [
       'Compiling financial data','Analyzing financial data','Creating periodic report','Presenting data',
       'Data capture', 'Computing taxes', 'Processing payments', 'Preparing budget','Preparing financial forecast'
     ],
     'Senior Accountant'=> ['Coordinating accounting functions','Preparing financial analyses',
                           'Preparing financial reports','Preparing revenue projections','forecasting expenditure',
                           'Assisting with preparing budgets.','Assisting with monitoring budgets.',
                           'Maintaining balance sheet', 'Maintaining general ledger accounts.',
                           'Assisting with annual audit preparations.','Preparing tax returns',
                           'Reconciling balance sheet ','Reconciling general ledger accounts.',
                           'Investigating audit findings','Resolving audit findings'
     ],
     'Procurement Specialist'=> ['Determining supply needs','Researching potential suppliers',
                                'Sourcing suppliers and testing product samples','Managing inventories ',
                                'generating monthly supply cost reports.','Preparing plans for the purchase of equipment',
                                'Preparing cost-benefit analysis reports','Negotiating favorable procurement contracts'],
     'Operations Officer'=> ['Developing new processes and procedures ','Determining the effectiveness of new processes.',
                            'Managing day-to-day operations.','Identifying ways to improve customer experiences.'],
     'Operations Manager'=> ['Managing the maintenance of office','Providing administrative support',
                            'Developing new processes and procedures','Determining the effectiveness of new processes.',
                            'Managing day-to-day operations.',],
     'Driver'=> ['Travel', 'Picking up mail', 'Traveling to clients', 'Waiting for service personnel'],
     'Software Developer'=> ['Proofreading code','Collaborating with UI and UX Designers','Conducting performance tests.',
                            'Designing and developing user interfaces','Developing product analysis tasks.',
                            'Consulting with the design team.','Developing software solutions'],
     'Snr Software Developer'=> ['Proofreading code','Collaborating with UI and UX Designers','Developing software solutions',
                                'Designing and developing user interfaces','Conducting performance tests.'],
     'Jnr Software Developer'=> ['Proofreading code','Collaborating with UI and UX Designers',
                                'Designing and developing user interfaces'],
     'Power Engineer'=> ['Developing specifications', 'installing equipment', 'troubleshooting installation',
                         'writing field report', 'travelling to client'],
     'Support Officer': ['documenting requests for support', 'Delivering IT and related assistance',
                         'Configuring new desktops, routers, modems, and similar devices',
                         'Providing suggestions on appropriate training for staff.','Responding to customer queries',
                         'Responding to customer complaints', 'Assisting client','Following up with customers'],
     'Deployment Officer': [],
     'Training Officer': ['Preparing instructional materials','Planning annual refresher courses',
                          'Annual refresher courses', 'User training','Administering regular needs assessments']
    }

    return tasks[role][Random.rand(tasks[role].length)]
end

main()
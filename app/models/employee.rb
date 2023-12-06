class Employee < ApplicationRecord
    belongs_to :person, :foreign_key =>  :person_id
    has_one :user, :foreign_key => :employee_id
    has_many :affiliations, :foreign_key => :employee_id
    has_many :employee_designations, :foreign_key => :employee_id

    def full_details(period="current")
        record = {}
        person = self.person
        record["id"] = self.id
        record["email"] = person.email_address
        record["gender"] = person.gender
        record["date_of_birth"] = person.birth_date
        record["phone_number"] = person.primary_phone
        record["employee_date"] = self.employment_date
        record["departure_date"] = self.departure_date
        record["marital_status"] = person.marital_status
        record["employee_name"] = {fname: person.first_name, mname: person.middle_name, lname: person.last_name}

        if period == "current"
            record["branch"] = current_affiliations.collect {|x| x.pretty_display}
            record["designations"] = current_designations.collect {|x| x.pretty_display}
            #record["supervisors"] = s
        else
            record["branch"] = employee_affiliations.collect {|x| x.pretty_display}
            record["designations"] = designations.collect {|x| x.pretty_display}
            #record["supervisors"] = s
        end
        return record
    end

    def current_position
        current_designations.collect {|x| x.pretty_display}.map{|x| x[:title]}.join(',')
    end

    def current_department
        current_affiliations.collect {|x| x.pretty_display}.map{|x| "#{x[:department_name]}"}.uniq.join(' | ')
    end
    def current_branches
        current_affiliations.collect {|x| x.pretty_display}.map{|x|
            "#{x[:branch_name]}, #{x[:branch_country]}"}.uniq.join(' | ')
    end
    def designations
        self.employee_designations
    end

    def current_designations
        self.employee_designations.where("end_date is null")
    end

    def employment_type
        designation = current_position
        if (designation.downcase.include? "intern") & !(designation.downcase.include? "volunteer")
            return "Internship"
        elsif designation.downcase.include? "volunteer"
            return "Volunteer"
        else
            return "Full-time"
        end
    end

    def employee_affiliations
        all_afflliations = self.affiliations
        return all_afflliations
    end

    def current_affiliations
        curr_afflliations = self.affiliations.where(is_terminated: false)
        return curr_afflliations
    end

    def current_projects
        return ProjectTeam.where(employee_id: self.employee_id, voided: false)
    end

    def loe (start_date = Date.today.beginning_of_month, end_date = Date.today.end_of_month)
        results = Hash.new(0.0)
        timesheets = Timesheet.select('timesheet_id').where("employee_id = ? and timesheet_week BETWEEN ? and ?",
                                                            self.employee_id, start_date.beginning_of_week,end_date )

        tasks = TimesheetTask.select("project_id, SUM(duration) as duration").where("timesheet_id in (?) and
                                  task_date BETWEEN  ? and ?", timesheets ,start_date, end_date).group(:project_id)

        cost_shared = Project.where("short_name in (?)", ['Crosscutting','Public Holiday','Annual Leave',
                                                          'Paternity Leave','Compassionate Leave',
                                                          'Sick Leave']).collect { |x| x.project_id }
        cost_shared_amount = 0.0

        (tasks || []).each do |task|
            if cost_shared.include?(task.project_id)
                cost_shared_amount += task.duration
            else
                results[task.project.short_name] = task.duration
            end
        end

        (self.current_projects || []).each do |proj|
           results[proj.project.short_name] += (proj.allocated_effort * cost_shared_amount)
        end

        return results
    end
end

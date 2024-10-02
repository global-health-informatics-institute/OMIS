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

    def current_supervisors
        people = Supervision.where(supervisee: self.employee_id, ended_on: nil)
    end
    def current_supervisees
        people = Supervision.where(supervisor: self.employee_id, ended_on: nil)
    end

    def used_leave_days (leave_days_start_date = Date.today.beginning_of_year, end_date = Date.today,
                         leave_type: 'Annual Leave')
        timesheets = Timesheet.select('timesheet_id').where("employee_id = ?", self.employee_id)
        leave_records = TimesheetTask.where('project_id = ? AND task_date between ? and ? and timesheet_id in (?)',
                                            Project.find_by_short_name(leave_type).project_id,
                                            leave_days_start_date, end_date, timesheets)
        leave_hours_taken = leave_records.sum { |record| record.duration}
        leave_days_taken = (leave_hours_taken/7.5).to_i
        return leave_days_taken
    end

    def compensatory_leave(start_date = 6.weeks.ago.to_date, end_date = Date.today)
        timesheets = Timesheet.select('timesheet_id').where("employee_id = ?", self.employee_id)
                              .collect { |x| x.timesheet_id }
        total_hours_worked = TimesheetTask.where('task_date between ? and ? and timesheet_id in (?) and
                                                 project_id not in (?)', start_date, end_date, timesheets,
                                                 Project.find_by_short_name("Compensatory Leave").project_id)
                                          .sum('duration').to_f
        weekdays_count = (start_date..end_date).count { |date| (1..5).include?(date.wday) }
        working_hours = GlobalProperty.find_by_property("number.of.hours").property_value.to_f
        compensatory_hours = TimesheetTask.where('project_id = ? AND task_date between ? and ? and timesheet_id in (?)',
                                                 Project.find_by_short_name("Compensatory Leave").project_id,
                                                 start_date, end_date, timesheets).sum('duration').to_f
        total_expected_hours = weekdays_count * working_hours
        total_extra_hours = total_hours_worked - total_expected_hours
        if total_extra_hours.positive?
            overtime_hours = total_extra_hours - compensatory_hours
        else
            overtime_hours = 0.0
        end
        return overtime_hours
    end

    def leave_balance(leave_type: 'Paternity Leave')
        unused_leave = (LeaveSummary.where(employee_id:  self.employee_id, leave_type: leave_type,
                                          financial_year: Date.today.year).first).leave_days_balance.floor(2)
        return unused_leave
    end

    def loe (start_date = Date.today.beginning_of_month, end_date = Date.today.end_of_month)
        results = Hash.new(0.0)
        timesheets = Timesheet.select('timesheet_id').where("employee_id = ? and timesheet_week BETWEEN ? and ?",
                                                            self.employee_id, start_date.beginning_of_week,end_date )

        tasks = TimesheetTask.select("project_id, SUM(duration) as duration").where("timesheet_id in (?) and
                                  task_date BETWEEN  ? and ?", timesheets ,start_date, end_date).group(:project_id)

        cost_shared = Project.where("short_name in (?)", ['Crosscutting','Public Holiday','Annual Leave',
                                                          'Paternity Leave','Compassionate Leave','Study Leave',
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
           results[proj.project.short_name] += ((proj.allocated_effort/100) * cost_shared_amount)
        end

        return results
    end

    def pending_actions
        # this function is for getting things that a person should act on
        actions = []

        # Get things that I need to do routinely as an employee

        # Get things that need my approval or review as a supervisor
        supervisor_transitions = WorkflowStateActor.where(by_supervisor: true)
        # Get things that need my approval or review based on my role

        # outstanding timesheets
        actions += Timesheet.select("timesheet_id, employee_id, timesheet_week")
                            .where("employee_id in (?) and submitted_on is NULL", self.id)
                            .collect{|x| ["Submit #{x.timesheet_week.strftime('%d %b, %Y')} timesheet",
                                          "/timesheets/#{x.id}"]}
        # timesheet reviews

        jnrs = self.current_supervisees.collect{|x| x.supervisee}

        actions += Timesheet.select("timesheet_id, employee_id, submitted_on, timesheet_week")
                            .where("employee_id in (?) and submitted_on is not NULL and approved_on is NULL", jnrs)
                            .collect{|x| ["Review #{x.employee.person.first_name}\'s #{x.timesheet_week.strftime('%d %b, %Y')} timesheet",
                                          "/timesheets/#{x.id}"]}

        allowed_transitions = WorkflowStateActor.where(employee_designation_id:
                                                         self.current_designations.collect{|x| x.id})
                                                .collect{|x| x.workflow_state_transition_id}

        # requisition finance reviews
        actions += Requisition.where("workflow_state_id in (?)" ,allowed_transitions)
                              .collect{ |x| ["Review #{x.user.person.first_name}\'s #{x.requisition_type} requisition",
                                             "/requisitions/#{x.id}"]}

        # self requisitions
        actions += Requisition.where("workflow_state_id in (?) and initiated_by in (?)", WorkflowStateTransition
                              .where(by_owner: true).collect{|x| x.workflow_state_id} , self.id )
                              .collect{|x| ["Check #{x.requisition_type} request for #{x.purpose}",
                                            "/requisitions/#{x.id}"]}

        # requisition reviews
        actions += Requisition.where("workflow_state_id in (?) and initiated_by not in (?)", WorkflowStateTransition
                              .where(by_supervisor: true).collect{|x| x.workflow_state_id} , self.id )
                              .collect { |x| ["Review #{x.user.person.first_name}\'s #{x.requisition_type} requisition",
                                              "/requisitions/#{x.id}"]}

        actions += LeaveRequest.where("status in (?) and employee_id in (?)", WorkflowStateTransition
                               .where(by_owner: true).collect{|x| x.workflow_state_id}, self.id)
                               .collect{|x| ["Review leave request", "/leave_requests/#{x.id}"]}

        actions += LeaveRequest.where("status in (?) and employee_id in (?) and approved_on is NULL", WorkflowStateTransition
                               .where(by_supervisor: true).collect{|x| x.workflow_state_id}, jnrs)
                               .collect{|x| ["Review #{x.user.person.first_name}'s' #{x.leave_type} request", "/leave_requests/#{x.id}"]}
        return actions
    end
end

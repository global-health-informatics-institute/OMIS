

def main 
   #create_summaries
   update_summary
end


def create_summaries
    leave_typees = {"Annual Leave": 21, "Study Leave": 20,
    "Sick Leave": 5,"Compassionate Leave": 5, "Paternity Leave": 10 }

    (Employee.all || []).each do |employee|
        (leave_typees || []).each do |k,v|
            LeaveSummary.create( employee_id: employee.id, leave_type: k, 
            leave_days_total: v,leave_days_balance: v, financial_year: 2024)
        end
        #update_summary(employee.id)
    end
end

def update_summary
    leave_types = ['Sick Leave','Annual Leave', 'Compassionate Leave']

    
    (Employee.all || []).each do |employee|
        leave_summary = LeaveSummary.where(employee_id: employee.id, leave_type: "Annual Leave", financial_year: 2024).first
        leave_summary.leave_days_balance -= total_days
        leave_summary.save
    end

end

main
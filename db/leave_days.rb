

def main 
   create_summaries
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

def update_summary(employee_id)
    leave_types = ['Sick Leave','Annual Leave', 'Compassionate Leave']



end

main
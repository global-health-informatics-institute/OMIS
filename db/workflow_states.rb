require 'csv'

def main
  create_states
end

def create_states
  source = "#{Rails.root}/db/data/#{ENV['data'] || 'demo'}"
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

    if !row[6].blank?
      (row[6].split(';')).each do |transitioner|
        WorkflowStateActor.create(workflow_state_id: wft.id,
                                  employee_designation_id: Designation.find_by_designated_role(transitioner).id)
      end
    end
  end
end

main

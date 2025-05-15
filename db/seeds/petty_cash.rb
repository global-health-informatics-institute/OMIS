require 'csv'

puts "Seeding started..."

# === Requisitions ===
puts "Seeding Requisitions..."
Requisition.delete_all

CSV.foreach(Rails.root.join('db/seeds/requisitions.csv'), headers: true) do |row|
  # Convert boolean values from string to actual booleans
  voided = row['voided'].nil? ? false : row['voided'].strip.downcase == 'true'
  
  # Convert NULL values to nil for optional fields
  reviewed_by = row['reviewed_by'] == 'NULL' ? nil : row['reviewed_by']
  approved_by = row['approved_by'] == 'NULL' ? nil : row['approved_by']
  
  # Create the requisition
  Requisition.create!(
    id: row['requisition_id'],
    purpose: row['purpose'],
    initiated_by: row['initiated_by'],
    initiated_on: row['initiated_on'],
    requisition_type: row['requisition_type'],
    reviewed_by: reviewed_by,
    approved_by: approved_by,
    workflow_state_id: row['workflow_state_id'],
    voided: voided,
    created_at: row['created_at'],
    updated_at: row['updated_at'],
    project_id: row['project_id'],
    approval_token: row['approval_token'],
    rejection_token: row['rejection_token'],
    approval_funds_token: row['approval_funds_token'],
    deny_funds_token: row['deny_funds_token']
  )
end

puts "Requisitions seeded successfully!"

# === Workflow States ===
puts "Seeding Workflow States..."
WorkflowState.delete_all

CSV.foreach(Rails.root.join('db/seeds/workflow_states.csv'), headers: true) do |row|
  voided_value = row['voided']&.strip&.downcase == 'true'
  
  WorkflowState.create!(
    id: row['workflow_state_id'],
    workflow_process_id: row['workflow_process_id'],
    state: row['state'],
    description: row['description'],
    voided: voided_value,
    created_at: row['created_at'],
    updated_at: row['updated_at']
  )
end

puts "Workflow States seeded successfully!"

# === Workflow State Actors ===
puts "Seeding Workflow State Actors..."
WorkflowStateActor.delete_all

processed_combinations = Set.new

CSV.foreach(Rails.root.join('db/seeds/workflow_state_actors.csv'), headers: true) do |row|
  combination_key = "#{row['workflow_state_id']}-#{row['employee_designation_id']}"
  next if processed_combinations.include?(combination_key)
  processed_combinations.add(combination_key)

  voided_value = row['voided']&.strip&.downcase == 'true'
  
  WorkflowStateActor.create!(
    id: row['id'],
    workflow_state_id: row['workflow_state_id'],
    employee_designation_id: row['employee_designation_id'],
    voided: voided_value,
    created_at: row['created_at'],
    updated_at: row['updated_at']
  )
end

puts "Workflow State Actors seeded successfully!"

# === Workflow State Transitions ===
puts "Seeding Workflow Transitions..."
WorkflowStateTransition.delete_all

CSV.foreach(Rails.root.join('db/seeds/workflow_state_transitions.csv'), headers: true) do |row|
  voided_value = row['voided']&.strip&.downcase == 'true'
  by_owner = row['by_owner']&.strip&.downcase == 'true'
  by_supervisor = row['by_supervisor']&.strip&.downcase == 'true'

  WorkflowStateTransition.create!(
    id: row['id'],
    workflow_state_id: row['workflow_state_id'],
    next_state: row['next_state'],
    voided: voided_value,
    created_at: row['created_at'],
    updated_at: row['updated_at'],
    action: row['action'],
    by_owner: by_owner,
    by_supervisor: by_supervisor
  )
end

puts "Seeding has successfully completed!"
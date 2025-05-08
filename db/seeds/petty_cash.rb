require 'csv'

puts "Seeding started..."

# === Workflow States ===

puts "Seeding Workflow States..."

# First delete all existing records
WorkflowState.delete_all

CSV.foreach(Rails.root.join('db/seeds/workflow_states.csv'), headers: true) do |row|
  voided_value = row['voided']&.strip&.downcase == 'true' # Handle nil and whitespace
  
  # Use the correct boolean value from CSV (not hardcoded 'true')
  voided = voided_value
  
  WorkflowState.create!(
    id: row['workflow_state_id'],
    workflow_process_id: row['workflow_process_id'],
    state: row['state'],
    description: row['description'],
    voided: true,
    created_at: row['created_at'],
    updated_at: row['updated_at']
  )
end

puts "Workflow States seeded successfully!"
# === Workflow State Designations ===
#require 'csv'

puts "Seeding started..."

# === Workflow State Actors ===
puts "Seeding Workflow State Actors..."
WorkflowStateActor.delete_all

# Track unique combinations we've already processed
processed_combinations = Set.new

CSV.foreach(Rails.root.join('db/seeds/workflow_state_actors.csv'), headers: true) do |row|
  # Create a unique key for this combination
  combination_key = "#{row['workflow_state_id']}-#{row['employee_designation_id']}"
  
  # Skip if we've already processed this combination
  next if processed_combinations.include?(combination_key)
  
  # Add to our processed set
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
puts "Seeding Workflow Transitions..."

CSV.foreach(Rails.root.join('db/seeds/workflow_state_transitions.csv'), headers: true) do |row|
  voided_value = row['voided']&.strip&.downcase == 'true'
  by_owner = row['by_owner']&.strip&.downcase == 'true'
  by_supervisor = row['by_supervisor']&.strip&.downcase == 'true'

  # Skip if record already exists
  next if WorkflowStateTransition.exists?(id: row['id'])

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

puts "seeding has successfully completed!"
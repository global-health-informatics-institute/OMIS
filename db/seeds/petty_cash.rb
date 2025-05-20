require 'csv'
require 'set'

puts "Seeding started..."

# === Workflow States ===
puts "Seeding Workflow States..."

CSV.foreach(Rails.root.join('db/seeds/workflow_states.csv'), headers: true) do |row|
  next if WorkflowState.exists?(workflow_state_id: row['workflow_state_id'])

  voided_value = row['voided']&.strip&.downcase == 'true'

  WorkflowState.create!(
    workflow_state_id: row['workflow_state_id'],
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

processed_combinations = Set.new

CSV.foreach(Rails.root.join('db/seeds/workflow_state_actors.csv'), headers: true) do |row|
  combination_key = "#{row['workflow_state_id']}-#{row['employee_designation_id']}"
  next if processed_combinations.include?(combination_key) || WorkflowStateActor.exists?(id: row['id'])

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

CSV.foreach(Rails.root.join('db/seeds/workflow_state_transitions.csv'), headers: true) do |row|
  next if WorkflowStateTransition.exists?(id: row['id'])

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

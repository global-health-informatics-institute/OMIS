require 'csv'
require 'set'

puts "Seeding started..."

# === Workflow States ===
puts "Seeding Workflow States..."

# Step 1: Mark all existing workflow states as voided to distinguish new/updated ones
WorkflowState.update_all(voided: true)

# Step 2: Read each row from the CSV and process it
CSV.foreach(Rails.root.join('db/seeds/workflow_states.csv'), headers: true) do |row|
  existing = WorkflowState.find_by(workflow_state_id: row['workflow_state_id'])

  # Normalize 'voided' value from CSV
  voided_value = row['voided']&.strip&.downcase == 'true'

  if existing
    # Update existing workflow state record
    existing.update!(
      workflow_process_id: row['workflow_process_id'],
      state: row['state'],
      description: row['description'],
      voided: voided_value,
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )
  else
    # Create new workflow state record
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
end

puts "Workflow States seeded successfully!"

# === Workflow State Actors ===
puts "Seeding Workflow State Actors..."

# Mark all existing state actors as voided
WorkflowStateActor.update_all(voided: true)

# Process each row in the CSV
CSV.foreach(Rails.root.join('db/seeds/workflow_state_actors.csv'), headers: true) do |row|
  voided_value = row['voided']&.strip&.downcase == 'true'

  # Look for existing record by ID
  existing = WorkflowStateActor.find_by(id: row['id'])

  if existing
    # Update existing state actor
    existing.update!(
      workflow_state_id: row['workflow_state_id'],
      employee_designation_id: row['employee_designation_id'],
      voided: voided_value,
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )
  else
    # Create new state actor entry
    WorkflowStateActor.create!(
      id: row['id'],
      workflow_state_id: row['workflow_state_id'],
      employee_designation_id: row['employee_designation_id'],
      voided: voided_value,
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )
  end
end

puts "Workflow State Actors seeded successfully!"

# === Workflow State Transitions ===
puts "Seeding Workflow Transitions starts..."

puts "Seeding Workflow Transitions starts..."
WorkflowStateTransition.update_all(voided: true)

transitions = CSV.foreach(Rails.root.join('db/seeds/workflow_state_transitions.csv'), headers: true).map do |row|
  {
    id: row['id'],
    workflow_state_id: row['workflow_state_id'],
    next_state: row['next_state'],
    voided: row['voided']&.strip&.downcase == 'true',
    created_at: row['created_at'],
    updated_at: row['updated_at'],
    action: row['action'],
    by_owner: row['by_owner']&.strip&.downcase == 'true',
    by_supervisor: row['by_supervisor']&.strip&.downcase == 'true'
  }
end

WorkflowStateTransition.upsert_all(transitions, unique_by: :id)
puts "Workflow State Transitions seeded successfully!"

puts "Seeding has successfully completed!"

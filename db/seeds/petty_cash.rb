require 'csv'
require 'set'

puts "Seeding started..."

# === Workflow States ===
puts "Seeding Workflow States..."

# Step 1: Void all existing records
WorkflowState.update_all(voided: true)

# Step 2: Process CSV rows
CSV.foreach(Rails.root.join('db/seeds/workflow_states.csv'), headers: true) do |row|
  existing = WorkflowState.find_by(workflow_state_id: row['workflow_state_id'])

  voided_value = row['voided']&.strip&.downcase == 'true'

  if existing
    existing.update!(
      workflow_process_id: row['workflow_process_id'],
      state: row['state'],
      description: row['description'],
      voided: voided_value,
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )
  else
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

# Mark all existing records as voided
WorkflowStateActor.update_all(voided: true)

CSV.foreach(Rails.root.join('db/seeds/workflow_state_actors.csv'), headers: true) do |row|
  voided_value = row['voided']&.strip&.downcase == 'true'

  # Check if the ID exists in the DB already
  existing = WorkflowStateActor.find_by(id: row['id'])

  if existing
    # If it exists, update the row (unvoid and update data)
    existing.update!(
      workflow_state_id: row['workflow_state_id'],
      employee_designation_id: row['employee_designation_id'],
      voided: voided_value,
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )
  else
    # If it does not exist, create a new one
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

puts "Seeding Workflow Transitions..."

# Step 1: Mark all existing records as voided
WorkflowStateTransition.update_all(voided: true)

# Step 2: Process each row from the CSV
CSV.foreach(Rails.root.join('db/seeds/workflow_state_transitions.csv'), headers: true) do |row|
  voided_value = row['voided']&.strip&.downcase == 'true'
  by_owner = row['by_owner']&.strip&.downcase == 'true'
  by_supervisor = row['by_supervisor']&.strip&.downcase == 'true'

  existing = WorkflowStateTransition.find_by(id: row['id'])

  if existing
    existing.update!(
      workflow_state_id: row['workflow_state_id'],
      next_state: row['next_state'],
      voided: voided_value,
      created_at: row['created_at'],
      updated_at: row['updated_at'],
      action: row['action'],
      by_owner: by_owner,
      by_supervisor: by_supervisor
    )
  else
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
end

puts "Workflow State Transitions seeded successfully!"

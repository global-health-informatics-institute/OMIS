require 'csv'
require 'set'

puts "Seeding started..."
# Ensure sequence is in sync to avoid duplicate ID errors
ActiveRecord::Base.connection.reset_pk_sequence!('workflow_state_transitions')


# --- Workflow States ---
puts "Seeding Workflow States..."

# Step 1: Mark all existing workflow states as voided.
# Records not present in the CSV will remain voided.
WorkflowState.update_all(voided: true)

# Keep track of IDs processed from the CSV for sanity checking if needed
processed_workflow_state_ids = Set.new

# Step 2: Read each row from the CSV and process it
CSV.foreach(Rails.root.join('db/seeds/workflow_states.csv'), headers: true) do |row|
  workflow_state_id = row['workflow_state_id']
  existing = WorkflowState.find_by(workflow_state_id: workflow_state_id)

  # Normalize 'voided' value from CSV
  voided_value = row['voided']&.strip&.downcase == 'true'

  attributes = {
    workflow_process_id: row['workflow_process_id'],
    state: row['state'],
    description: row['description'],
    voided: voided_value,
    created_at: Time.current,
    updated_at: Time.current
  }

  if existing
    # Update existing workflow state record with values from CSV
    existing.update!(attributes)
  else
    # Create new workflow state record
    WorkflowState.create!(attributes.merge(workflow_state_id: workflow_state_id))
  end

  processed_workflow_state_ids.add(workflow_state_id)
end

puts "Workflow States seeded successfully!"

# --- Workflow State Actors ---
puts "Seeding Workflow State Actors..."

# Mark all existing state actors as voided
WorkflowStateActor.update_all(voided: true)

# Process each row in the CSV
CSV.foreach(Rails.root.join('db/seeds/workflow_state_actors.csv'), headers: true) do |row|
  # We should only use the 'id' from the CSV to find an existing record.
  # For new records, let the database assign the 'id'.
  csv_id = row['id'] # Keep this to find existing

  voided_value = row['voided']&.strip&.downcase == 'true'

  attributes = {
    workflow_state_id: row['workflow_state_id'],
    employee_designation_id: row['employee_designation_id'],
    voided: voided_value,
    created_at: Time.current,
    updated_at: Time.current
  }

  # Look for existing record by the 'id' from CSV
  # Use `find_by(id: csv_id)` or `find_by_id(csv_id)` if `id` is truly unique and you want to use it
  # for lookup.
  existing = WorkflowStateActor.find_by(id: csv_id) # <--- Find by the CSV ID

  if existing
    # Update existing state actor with values from CSV
    existing.update!(attributes)
  else
    # Create new state actor entry. DO NOT include `id: csv_id` here.
    # The database will automatically assign a new unique ID.
    WorkflowStateActor.create!(attributes) # <--- Removed id: csv_id
  end
end
puts "Workflow State Actors seeded successfully!"

# --- Workflow State Transitions ---
puts "Seeding Workflow Transitions starts..."

WorkflowStateTransition.update_all(voided: true)

CSV.foreach(Rails.root.join('db/seeds/workflow_state_transitions.csv'), headers: true) do |row|
  # Normalize boolean values
  voided_value = row['voided']&.strip&.downcase == 'true'
  by_owner = row['by_owner']&.strip&.downcase == 'true'
  by_supervisor = row['by_supervisor']&.strip&.downcase == 'true'

  attributes = {
    workflow_state_id: row['workflow_state_id'],
    next_state: row['next_state'],
    voided: voided_value,
    created_at: Time.current,
    updated_at: Time.current,
    action: row['action'],
    by_owner: by_owner,
    by_supervisor: by_supervisor
  }

  # Find existing record by something other than `id` (like a composite key, if any)
  existing = WorkflowStateTransition.find_by(
    workflow_state_id: row['workflow_state_id'],
    next_state: row['next_state'],
    action: row['action']
  )

  if existing
    existing.update!(attributes)
  else
    WorkflowStateTransition.create!(attributes) # No CSV ID included at all
  end
end

puts "Seeding has successfully completed!"


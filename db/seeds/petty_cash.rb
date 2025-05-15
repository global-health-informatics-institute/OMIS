require 'csv'
require 'set'

puts "Seeding started..."

# === Requisitions ===
puts "Seeding Requisitions..."
Requisition.delete_all

filepath = Rails.root.join('db', 'seeds', 'requisitions.csv')

begin
  rows = CSV.read(filepath, headers: true)
  if rows.empty?
    puts "No requisition data found in CSV file: #{filepath}"
  else
    rows.each do |row|
      puts "Processing requisition: #{row['requisition_id']}"
      # Convert boolean values from string to actual booleans
      voided = row['voided'].nil? ? false : row['voided'].strip.downcase == 'true'

      # Convert NULL values to nil for optional fields
      reviewed_by = row['reviewed_by'] == 'NULL' ? nil : row['reviewed_by']
      approved_by = row['approved_by'] == 'NULL' ? nil : row['approved_by']

      # Attempt to create the requisition, with error handling
      begin
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
        puts "Successfully created requisition: #{row['requisition_id']}"
      rescue ActiveRecord::RecordInvalid => e
        puts "Error creating requisition #{row['requisition_id']}: #{e.message}"
        puts "Row data: #{row.to_hash.inspect}"
      rescue => e
        puts "An unexpected error occurred while creating requisition #{row['requisition_id']}: #{e.message}"
        puts "Row data: #{row.to_hash.inspect}"
      end
    end
  end
rescue CSV::MalformedCSVError => e
  puts "Error reading CSV file #{filepath}: #{e.message}"
rescue Errno::ENOENT => e
  puts "CSV file not found at: #{filepath}"
rescue => e
  puts "An unexpected error occurred while processing the CSV file: #{e.message}"
end

puts "Requisitions seeded successfully!"

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
WorkflowStateTransition.delete_all

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

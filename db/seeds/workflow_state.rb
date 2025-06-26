

# Execute with:
# bundle exec rails runner "db/seeds/workflow_state.rb"
# This script clears existing WorkflowState (via void or delete),
# then loads new states from a JSON source file.
require 'json'
puts '[MISSION] Initiating WorkflowState seeding operation...'

file_path = Rails.root.join('db/seeds/workflow_states.json')

ActiveRecord::Base.transaction do
  if WorkflowState.column_names.include?('voided')
    WorkflowState.update_all(voided: true)
    ActiveRecord::Base.connection.reset_pk_sequence!('workflow_states')
    puts '[ACTION] Existing states marked as voided.'
  else
    WorkflowState.delete_all
    puts '[ACTION] Existing states deleted — no "voided" column detected.'
  end

  json_data = JSON.parse(File.read(file_path))
  now = Time.current

  puts "[INTEL] Loaded #{json_data.size} state records from JSON payload."

  WorkflowState.upsert_all(
  json_data.map { |attrs| attrs.merge(created_at: now, updated_at: now) },
  unique_by: :workflow_state_id
  )
  puts '[STATUS] All workflowState records deployed successfully.'
end

puts '[MISSION COMPLETE] WorkflowState seeding operation concluded.'
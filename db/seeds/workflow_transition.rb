# frozen_string_literal: true

# Execute with:
# bundle exec rails runner "db/seeds/workflow_transition.rb"
# This script clears existing WorkflowStateTransitions (via void or delete),
# then loads new transitions from a JSON source file.

require 'json'

puts '[MISSION] Initiating WorkflowStateTransition seeding operation...'

file_path = Rails.root.join('db/seeds/workflow_state_transitions_seed.json')

ActiveRecord::Base.transaction do
  if WorkflowStateTransition.column_names.include?('voided')
    WorkflowStateTransition.update_all(voided: true)
    ActiveRecord::Base.connection.reset_pk_sequence!('workflow_state_transitions')
    puts '[ACTION] Existing transitions marked as voided.'
  else
    WorkflowStateTransition.delete_all
    puts '[ACTION] Existing transitions deleted — no "voided" column detected.'
  end

  json_data = JSON.parse(File.read(file_path))
  now = Time.current

  puts "[INTEL] Loaded #{json_data.size} transition records from JSON payload."

  json_data.each do |attrs|
    WorkflowStateTransition.create!(attrs.merge(created_at: now, updated_at: now))
  end

  puts '[STATUS] All transition records deployed successfully.'
end

puts '[MISSION COMPLETE] WorkflowStateTransition seeding operation concluded.'


# Execute with:
# bundle exec rails runner "db/seeds/workflow_state_actors.rb"
# This script clears existing WorkflowStateActors (via void or delete),
# then loads new actors from a JSON source file.
require 'json'
puts '[MISSION] Initiating WorkflowStateActor seeding operation...'

file_path = Rails.root.join('db/seeds/workflow_state_actors.json')

ActiveRecord::Base.transaction do
  if WorkflowStateActor.column_names.include?('voided')
    WorkflowStateActor.update_all(voided: true)
    ActiveRecord::Base.connection.reset_pk_sequence!('workflow_state_actors')
    puts '[ACTION] Existing actors marked as voided.'
  else
    WorkflowStateActor.delete_all
    puts '[ACTION] Existing actors deleted — no "voided" column detected.'
  end

  json_data = JSON.parse(File.read(file_path))
  now = Time.current

  puts "[INTEL] Loaded #{json_data.size} actor records from JSON payload."

  json_data.each do |attrs|
    WorkflowStateActor.create!(attrs.merge(created_at: now, updated_at: now))
  end

  puts '[STATUS] All actor records deployed successfully.'
end

puts '[MISSION COMPLETE] WorkflowStateActor seeding operation concluded.'

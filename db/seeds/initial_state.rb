# Execute with:
# bundle exec rails runner "db/seeds/initial_state.rb"
# This script clears existing WorkflowStates (via void or delete),
# then loads new workflow states from a JSON source file.

require 'json'
puts '[MISSION] Initiating Initial State seeding operation...'

file_path = Rails.root.join('db/seeds/initial_state.json')

ActiveRecord::Base.transaction do
  if InitialState.column_names.include?('voided')
    InitialState.update_all(voided: true)
    ActiveRecord::Base.connection.reset_pk_sequence!('initial_states')
    puts '[ACTION] Existing initial states marked as voided.'
  else
    InitialState.delete_all
    puts '[ACTION] Existing initial states deleted — no "voided" column detected.'
  end

  json_data = JSON.parse(File.read(file_path))
  now = Time.current

  puts "[INTEL] Loaded #{json_data.size} initial state records from JSON payload."

  json_data.each do |attrs|
    InitialState.create!(attrs.merge(created_at: now, updated_at: now))
  end

  puts '[STATUS] All Initial State records deployed successfully.'
end

puts '[MISSION COMPLETE] Initial State seeding operation concluded.'

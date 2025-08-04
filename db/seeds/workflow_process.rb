# Execute with:
# bundle exec rails runner "db/seeds/workflow_process.rb"
# This script clears existing WorkflowProcesses (via void or delete),
# then loads new workflow processes from a JSON source file.

require 'json'
puts '[MISSION] Initiating WorkflowProcess seeding operation...'

file_path = Rails.root.join('db/seeds/workflow_process.json')

ActiveRecord::Base.transaction do
  if WorkflowProcess.column_names.include?('voided')
    WorkflowProcess.update_all(voided: true)
    ActiveRecord::Base.connection.reset_pk_sequence!('workflow_processes')
    puts '[ACTION] Existing workflow processes marked as voided.'
  else
    WorkflowProcess.delete_all
    puts '[ACTION] Existing workflow processes deleted — no "voided" column detected.'
  end

  json_data = JSON.parse(File.read(file_path))
  now = Time.current

  puts "[INTEL] Loaded #{json_data.size} workflow process records from JSON payload."

  json_data.each do |attrs|
    WorkflowProcess.create!(attrs.merge(created_at: now, updated_at: now))
  end

  puts '[STATUS] All workflow process records deployed successfully.'
end

puts '[MISSION COMPLETE] WorkflowProcess seeding operation concluded.'

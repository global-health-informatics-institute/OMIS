# Execute with:
# bundle exec rails runner "db/seeds/stakeholders.rb"
# This script clears existing Stakeholders (via void or delete),
# then loads new stakeholders from a JSON source file.

require 'json'
puts '[MISSION] Initiating Stakeholder seeding operation...'

file_path = Rails.root.join('db/seeds/stakeholder.json')

ActiveRecord::Base.transaction do
  if Stakeholder.column_names.include?('voided')
    Stakeholder.update_all(voided: true)
    ActiveRecord::Base.connection.reset_pk_sequence!('stakeholders')
    puts '[ACTION] Existing stakeholders marked as voided.'
  else
    Stakeholder.delete_all
    puts '[ACTION] Existing stakeholders deleted — no "voided" column detected.'
  end

  json_data = JSON.parse(File.read(file_path))
  now = Time.current

  puts "[INTEL] Loaded #{json_data.size} stakeholder records from JSON payload."

  json_data.each do |attrs|
    Stakeholder.create!(attrs.merge(created_at: now, updated_at: now))
  end

  puts '[STATUS] All stakeholder records deployed successfully.'
end

puts '[MISSION COMPLETE] Stakeholder seeding operation concluded.'

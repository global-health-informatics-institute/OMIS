# Execute with:
# bundle exec rails runner "db/seeds/global_property.rb"
# This script appends new global properties from a JSON file without modifying existing ones.

require 'json'

puts '[MISSION] Initiating global properties seeding operation (append-only)...'

file_path = Rails.root.join('db/seeds/global_properties.json')

json_data = JSON.parse(File.read(file_path))
now = Time.current

puts "[INTEL] Loaded #{json_data.size} property records from JSON payload."

existing_properties = GlobalProperty.pluck(:property).to_set

new_records = json_data.reject { |attrs| existing_properties.include?(attrs['property']) }

if new_records.any?
  GlobalProperty.insert_all(
    new_records.map { |attrs| attrs.merge(created_at: now, updated_at: now) }
  )
  puts "[STATUS] #{new_records.size} new global properties appended successfully."
else
  puts '[STATUS] No new properties to insert. All records already exist.'
end

puts '[MISSION] Global properties append-only operation completed.'

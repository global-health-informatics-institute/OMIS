# run directly as:
# bundle exec rails runner 'load "db/seeds/dashboard_metadata.rb"'
# Seed script that checks if the `dashboard.metadata` exists in the Model `GlobalProperty`
# If it does not exist, it creates a new record with the specified metadata.
# This is useful for populating dashboard assets.

# Check if the dashboard metadata already exists
dashboard_metadata = GlobalProperty.find_by(property: 'dashboard.metadata')

# If it doesn't exist, create it with default values
if dashboard_metadata.nil?
  GlobalProperty.create(
    property: 'dashboard.metadata',
    property_value: 'GHII,ghii-logo.png',
    description: 'Metadata for the Dashboard, including organization shortname and logo; metadata is customizable and depend on logic to extract from the database' # rubocop:disable Layout/LineLength
  )
end

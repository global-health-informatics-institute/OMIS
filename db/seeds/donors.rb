# frozen_string_literal: true

# TODO: replace with actual data
# db/seeds/donors.rb
puts 'Seeding donors'

DONOR_NAMES =
  [
    {
      short_name: 'Donor A',
      name: 'Donor ABC',
      description: 'Donor ABC description'
    },
    {
      short_name: 'Donor B',
      name: 'Donor B',
      description: 'Donor B description'
    },
    {
      short_name: 'Donor C',
      name: 'Donor C',
      description: 'Donor C description'
    },
    {
      short_name: 'Donor D',
      name: 'Donor D',
      description: 'Donor D description'
    },
    {
      short_name: 'Donor E',
      name: 'Donor E',
      description: 'Donor E description'
    },
    {
      short_name: 'Donor F',
      name: 'Donor F',
      description: 'Donor F description'
    },
    {
      short_name: 'Donor G',
      name: 'Donor G',
      description: 'Donor G description'
    },
    {
      short_name: 'Donor H',
      name: 'Donor H',
      description: 'Donor H description'
    },
    {
      short_name: 'Donor I',
      name: 'Donor I',
      description: 'Donor I description'
    }
  ].freeze
ActiveRecord::Base.transaction do
  puts 'Resetting DonorProject associations'
  # It is usually safe to reset the many-to-many project links
  DonorProject.destroy_all 

  # DO NOT destroy_all Donors here!

  # create or update Donors
  DONOR_NAMES.each do |donor_data|
    # Find the donor by short_name, or initialize a new one if it doesn't exist
    donor = Donor.find_or_initialize_by(short_name: donor_data[:short_name])

    # Assign the next available ID ONLY if this is a brand new donor
    donor.donor_id = (Donor.maximum(:donor_id) || 0) + 1 if donor.new_record?

    donor.name = donor_data[:name]
    donor.description = donor_data[:description]
    donor.save!
  end
  puts "Completed seeding #{Donor.count} donors"

  # Create associations
  # assigns 1 to 3 projects for each donor
  project_ids = Project.pluck(:project_id)

  Donor.find_each do |donor|
    project_ids.sample(rand(1..3)).each do |project_id|
      DonorProject.find_or_create_by!(
        donor_id: donor.id,
        project_id: project_id
      )
    end
  end
end

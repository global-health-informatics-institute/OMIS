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
  # Clean donor associations before deleting donors.
  puts "Deleting #{DonorProject.count} ProjectDonors  & #{Donor.count} Donors"
  DonorProject.destroy_all
  Donor.destroy_all

  # create Donors
  DONOR_NAMES.each do |donor|
    next_id = (Donor.maximum(:donor_id) || 0) + 1

    Donor.find_or_create_by(
      donor_id: next_id,
      short_name: donor[:short_name],
      name: donor[:name],
      description: donor[:description]
    )
  end
  puts "Completed seeding #{Donor.count} donors"

  # Create associations
  # assigns 1 to 3 projects for each donor
  project_ids = Project.pluck(:project_id)

  Donor.find_each do |donor|
    project_ids.sample(rand(1..3)).each do |project_id|
      DonorProject.find_or_create_by(
        donor_id: donor.id,
        project_id:
      )
    end
  end
end

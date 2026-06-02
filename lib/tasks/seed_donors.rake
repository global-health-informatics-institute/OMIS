# frozen_string_literal: true

# lib/tasks/seed_donors.rake
# run with: bundle exec rails db:seed:donors
namespace :db do
  namespace :seed do
    desc 'Seed donors from db/seeds/donors.rb'
    task donors: :environment do
      seed_file = Rails.root.join('db', 'seeds', 'donors.rb')
      if File.exist?(seed_file)
        load(seed_file)
      else
        puts "Seed file not found at #{seed_file}"
      end
    end
  end
end

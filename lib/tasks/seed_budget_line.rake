# frozen_string_literal: true

# lib/tasks/seed_budget_line.rake
# run with: bundle exec rails db:seed:budget_line
namespace :db do
  namespace :seed do
    desc 'Seed budget_line from db/seeds/budget_line.rb'
    task budget_line: :environment do
      seed_file = Rails.root.join('db', 'seeds', 'budget_line.rb')
      if File.exist?(seed_file)
        load(seed_file)
      else
        puts "Seed file not found at #{seed_file}"
      end
    end
  end
end

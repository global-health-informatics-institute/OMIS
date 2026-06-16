# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc 'Seed budget lines, donors, workflow states, and workflow processes'
    task purchase_request_setup: :environment do
      # Defined in logical order of dependencies
      seed_files = [
        'donors.rb',
        'budget_lines.rb',
        'purchase_request_workflow_data.rb'
      ]

      seed_files.each do |file|
        path = Rails.root.join('db', 'seeds', file)

        if File.exist?(path)
          puts "== Seeding: #{file} =="
          load(path)
        else
          puts "== Warning: #{file} not found at #{path} =="
        end
      end

      puts '== All Purchase Request seeds completed! =='
    end
  end
end

namespace :custom_seed do
  desc "Seed petty cash-related data only"
  task petty_cash: :environment do
    require Rails.root.join('db', 'seeds', 'petty_cash.rb')  # Correct file path
    puts "Petty cash seed completed."
  end
end

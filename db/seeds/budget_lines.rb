# frozen_string_literal: true

# TODO: replace with actual data
# db/seeds/budget_line.rb
puts 'Seeding budget_line'

BUDGETLINE_NAMES =
  [
    {
      budget_line_ref: 'BudgetLineA',
      description: 'description for A'
    },
    {
      budget_line_ref: 'BudgetLineB',
      description: 'description for B'
    },
    {
      budget_line_ref: 'BudgetLineC',
      description: 'description for C'
    },
    {
      budget_line_ref: 'BudgetLineD',
      description: 'description for D'
    },
    {
      budget_line_ref: 'BudgetLineE',
      description: 'description for E'
    }
  ].freeze

ActiveRecord::Base.transaction do
  # Clean BudgetLine associations before deleting donors.
  puts "Deleting #{BudgetLine.count} BudgetLine"
  BudgetLine.destroy_all

  # create Donors
  BUDGETLINE_NAMES.each do |budget_line|
    next_id = (BudgetLine.maximum(:id) || 0) + 1

    BudgetLine.find_or_create_by(
      id: next_id,
      budget_line_ref: budget_line[:budget_line_ref],
      description: budget_line[:description]
    )
  end
  puts "Completed seeding #{BudgetLine.count} budget lines"
end

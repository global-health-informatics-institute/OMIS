# frozen_string_literal: true

# TODO: replace with actual data
# db/seeds/budget_lines.rb
puts 'Seeding budget_lines'

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
  # We do NOT destroy BudgetLines here to prevent Foreign Key violations
  # with the requisition_budget_lines table.

  BUDGETLINE_NAMES.each do |budget_line_data|
    # Find the budget line by its reference, or initialize a new one
    budget_line = BudgetLine.find_or_initialize_by(budget_line_ref: budget_line_data[:budget_line_ref])

    # Update the description (and any other future fields)
    budget_line.description = budget_line_data[:description]
    budget_line.save!
  end

  puts "Completed seeding #{BudgetLine.count} budget lines"
end

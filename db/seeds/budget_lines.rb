# frozen_string_literal: true

require 'csv'

puts 'Seeding budget_lines'

ActiveRecord::Base.transaction do
  # We do NOT destroy BudgetLines here to prevent Foreign Key violations
  # with the requisition_budget_lines table.

  # category => its budget line refs
  # The csv columns are the categories. They are seeded left to right and the refs inside a
  # category top to bottom, so records are created category by category in csv order
  # (not row by row across all categories).
  budget_lines_by_category = { 'Unbudgeted' => ['Unbudgeted'] }

  table = CSV.read(Rails.root.join('db/seeds/budget_lines.csv'), headers: true)
  table.headers.each do |category|
    next if category.blank?

    budget_lines_by_category[category.strip] = table[category].map { |ref| ref.to_s.strip }.reject(&:blank?)
  end

  # a ref can only belong to one category, otherwise the later category would silently take it over
  duplicates = budget_lines_by_category.values.flatten.tally.select { |_, count| count > 1 }.keys
  raise "Budget line ref in more than one category: #{duplicates.join(', ')}" unless duplicates.empty?

  budget_lines_by_category.each do |category, budget_line_refs|
    budget_line_refs.each do |budget_line_ref|
      budget_line = BudgetLine.find_or_initialize_by(budget_line_ref: budget_line_ref)
      budget_line.category = category
      budget_line.save!
    end

    puts "  #{category}: #{budget_line_refs.size}"
  end
  puts "Completed seeding #{BudgetLine.count} budget lines"
end

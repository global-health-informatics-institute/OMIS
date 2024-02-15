require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

source = "#{Rails.root}/db/data/#{ENV['data'] || 'demo'}"
puts "Seeding the database with #{ENV['data']} data"
puts "Adding Branches"
CSV.foreach("#{source}/branches.csv",:headers=>:true) do |row|
  Branch.create(branch_name: row[0], city: row[2], country: row[1], location: row[3])
end

puts "Adding Departments"
CSV.foreach("#{source}/departments.csv",:headers=>:true) do |row|
  branch = Branch.find_by_branch_name(row[0])
  Department.create(branch_id: branch.id, department_name: row[1])
end

puts "Adding Designations"
CSV.foreach("#{source}/designations.csv",:headers=>:true) do |row|
  department = Department.joins(:branch).where('branches.branch_name' => row[0],
                                               department_name: row[1])
  Designation.create(department_id: department.id, designated_role: row[2])
end

puts "Adding people"


puts "Seeding database done"
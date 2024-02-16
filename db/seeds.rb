# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

project = Project.where(
    project_name: 'Ambulance Oxygen Concentrator', 
    project_description: 'GIZ funded project to develop and ambulance oxygen concentrator', 
    manager: 1, created_by: 1, 
    short_name: 'P02C').first_or_create

CSV.foreach('db/data/demo/project_data.csv', headers: true) do |row|

    ProjectTask.create({
      project_id: project.id,
      task_description: row[1],
      created_at: row[2],
      deadline: Date.strptime(row[3], '%m/%d/%Y'),
      #estimated_duration: (Date.strptime(row[3], '%m/%d/%Y') - row[2])
    })
  end


# frozen_string_literal: true

# seed script to define the purchase request workflow process and associated data.

# Donors
# TODO: Use actual donor names and data when available. This is just placeholder data for now.

puts 'Start Donor seeding'
donor_names = [
  'Donor A',
  'Donor B',
  'Donor C',
  'Donor D',
  'Donor E',
  'Donor F',
  'Donor G',
  'Donor H',
  'Donor I'
]

# BudgeLines
# TODO: Use actual budget line names and data when available. This is just placeholder data for now.
puts 'Start BudgetLine seeding'
budget_line_names = [
  'Budget Line A',
  'Budget Line B',
  'Budget Line C',
  'Budget Line D',
  'Budget Line E',
  'Budget Line F',
  'Budget Line G',
  'Budget Line H',
  'Budget Line I'
]


ActiveRecord::Base.transaction do

donor_names.each do |name|
  # Skip if already exists
  next if Donor.exists?(short_name: name)

  next_id = (Donor.maximum(:donor_id) || 0) + 1

  Donor.find_or_create_by(
    donor_id: next_id,
    short_name: name
  )
end
puts "Seeded #{Donor.count} donors."


budget_line_names.each do |name|
  # Skip if already exists
  next if BudgetLine.exists?(name:)

  next_id = (BudgetLine.maximum(:budget_line_id) || 0) + 1

  BudgetLine.find_or_create_by!(
    budget_line_id: next_id,
    name:
  )
end
puts "Seeded #{BudgetLine.count} budget lines."

# DonorProjects
# TODO: Use actual donor project names and data when available. This is just placeholder data for now.
puts 'Start DonorProject seeding'

donor_length = Donor.count
count = 0
project_id_array = Project.all.limit(rand(1..donor_length)).pluck(:project_id)

Donor.all.each do |donor|
  next if count >= donor_length

  count += 1
  project_id_array.each do |project_id|
    # Skip if already exists
    next if DonorProject.exists?(donor_id: donor.donor_id, project_id:)

    DonorProject.find_or_create_by!(
      donor_id: rand(1..donor_length),
      project_id:
    )
  end
end
puts "Seeded #{DonorProject.count} donor projects."

# WorkflowProcess
    WorkflowProcess.find_or_create!(workflow: 'Purchase Request')
    end

  # WorkflowStates: These are status given to a requesition at different stages of its workflow
  # These are used in WorkflowStateTransition to define the possible transitions (actions) between states in the workflow.

  workflow_states = [
    { state: 'Pending Submission', description: 'State where the purchase request is open for editing or simply the initial state'},
    { state: 'Requested', description: 'The purchase request has been created and is awaiting review from the supervisor' },
    { state: 'Approved', description: 'The purchase request has been approved and is ready for processing.' },
    { state: 'Declined', description: 'The purchase request has been rejected and will not be processed.' }
  ]

  # actions
  workflow_state_transitions = [
    {
      workflow_state_id: 'Pending Submission',
      next_state: 'Requested',
      action: 'Submit Purchase Request',
      by_owner: true,
      by_supervisor: false
    },
    {
      workflow_state_id: 'Requested',
      next_state: 'Approved',
      action: 'Approve Purchase Request',
      by_owner: false,
      by_supervisor: true
    },
    {
      workflow_state_id: 'Requested',
      next_state: 'Declined',
      action: 'Decline Purchase Request',
      by_owner: true,
      by_supervisor: false
    }
  ]

  # WorkflowStateActors: Assigning previledges to different roles

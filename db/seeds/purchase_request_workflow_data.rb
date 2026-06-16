# frozen_string_literal: true

# TODO: replace with actual data
# db/seeds/workflow_processes.rb
WORKFLOW_PROCESS = {
  workflow: 'Purchase Request',
  active: true
}.freeze

WORKFLOW_STATE = [
  {
    state: 'Requested',
    description: 'Initial state when a purchase request is created'
  }
].freeze

ActiveRecord::Base.transaction do
  # create workflow processes
  WorkflowProcess.find_or_create_by(
    workflow: WORKFLOW_PROCESS[:workflow]
  )
  puts "Created WorkflowProcess: #{WORKFLOW_PROCESS[:workflow]}"

  WORKFLOW_PROCESS_ID = WorkflowProcess.find_by( # rubocop:disable Lint/ConstantDefinitionInBlock
    workflow: WORKFLOW_PROCESS[:workflow]
  )&.workflow_process_id

  # workflow states
  WORKFLOW_STATE.each do |workflow_state|
    next_id = (WorkflowState.maximum(:workflow_state_id) || 0) + 1

    WorkflowState.find_or_create_by(
      workflow_state_id: next_id,
      workflow_process_id: WORKFLOW_PROCESS_ID,
      state: workflow_state[:state],
      description: workflow_state[:description]
    )
    puts "Created WorkflowState: #{workflow_state[:state]} with ID #{next_id}"
  end

  INITIAL_WORKFLOW_STATE_ID = WorkflowState.find_by( # rubocop:disable Lint/ConstantDefinitionInBlock
    workflow_process_id: WORKFLOW_PROCESS_ID,
    state: WORKFLOW_STATE.first[:state]
  )&.workflow_state_id

  # initial state
  InitialState.find_or_create_by(
    workflow_process_id: WORKFLOW_PROCESS_ID,
    workflow_state_id: INITIAL_WORKFLOW_STATE_ID
  )
  puts "Created InitialState: #{WORKFLOW_STATE.first[:state]}"
end

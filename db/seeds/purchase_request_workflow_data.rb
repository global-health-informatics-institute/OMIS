# frozen_string_literal: true

# TODO: replace with actual data
# db/seeds/workflow_processes.rb
WORKFLOW_PROCESS = {
  workflow: 'Purchase Request',
  active: true
}.freeze

WORKFLOW_STATE = [
  {
    state: 'Pending Submission',
    description: 'Initial state which triggers the opening of a purchase request'
  },
  {
    state: 'Requested',
    description: 'State when a purchase request is created'
  }
].freeze

WORKFLOW_STATE_TRANSITIONS = [
  {
    workflow_state_id: 'Pending Submission',
    next_state: 'Requested',
    action: 'Submit Purchase Request',
    by_owner: true,
    by_supervisor: false
  }
].freeze

# helper methods
def _get_workflow_state_id(workflow_process_name, state)
  WorkflowState.find_by(
    workflow_process_id: _get_workflow_process_id(workflow_process_name),
    state:
  )&.workflow_state_id
end

def _get_workflow_process_id(workflow_process_name)
  WorkflowProcess.find_by(workflow: workflow_process_name)&.workflow_process_id
end

ActiveRecord::Base.transaction do # rubocop:disable Metrics/BlockLength
  # DESTROY EXISTING DATA

  # workflow transitions
  WORKFLOW_STATE_TRANSITIONS.each do |workflow_state_transition|
    existing_transition = WorkflowStateTransition.find_by(
      workflow_state_id: _get_workflow_state_id(WORKFLOW_PROCESS[:workflow],
                                                workflow_state_transition[:workflow_state_id])
    )
    existing_transition&.destroy

    puts "Destroyed WorkflowStateTransition: #{workflow_state_transition[:workflow_state_id]})" if existing_transition
  end

  # all workflow states
  WorkflowState.find_by(
    workflow_process_id: _get_workflow_process_id(WORKFLOW_PROCESS[:workflow])
  )&.destroy
  puts 'Destroyed Workflow States for workflow'

  # initial state
  InitialState.find_by(
    workflow_process_id: _get_workflow_process_id(WORKFLOW_PROCESS[:workflow])
  )&.destroy

  # CREATE NEW DATA

  # create workflow processes
  WorkflowProcess.find_or_create_by(
    workflow: WORKFLOW_PROCESS[:workflow]
  )
  puts "Created WorkflowProcess: #{WORKFLOW_PROCESS[:workflow]}"

  # workflow states
  WORKFLOW_STATE.each do |workflow_state|
    next_id = (WorkflowState.maximum(:workflow_state_id) || 0) + 1

    WorkflowState.find_or_create_by(
      workflow_process_id: _get_workflow_process_id(WORKFLOW_PROCESS[:workflow]),
      state: workflow_state[:state],
      description: workflow_state[:description]
    )
    puts "Created WorkflowState: #{workflow_state[:state]} with ID #{next_id}"
  end

  WORKFLOW_STATE_TRANSITIONS.each do |workflow_state_transition|
    WorkflowStateTransition.find_or_create_by(
      workflow_state_id: _get_workflow_state_id(WORKFLOW_PROCESS[:workflow],
                                                workflow_state_transition[:workflow_state_id]),
      next_state: _get_workflow_state_id(WORKFLOW_PROCESS[:workflow], workflow_state_transition[:next_state]),
      action: workflow_state_transition[:action],
      by_owner: workflow_state_transition[:by_owner],
      by_supervisor: workflow_state_transition[:by_supervisor]
    )
  end

  # initial state
  InitialState.find_or_create_by(
    workflow_process_id: _get_workflow_process_id(WORKFLOW_PROCESS[:workflow]),
    workflow_state_id: _get_workflow_state_id(WORKFLOW_PROCESS[:workflow], WORKFLOW_STATE.first[:state])
  )
  puts "Created InitialState: #{WORKFLOW_STATE.first[:state]}"
end
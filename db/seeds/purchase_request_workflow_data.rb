# frozen_string_literal: true

# TODO: replace with actual data
# db/seeds/workflow_processes.rb
WORKFLOW_PROCESS = {
  workflow: 'Purchase Request',
  active: true
}.freeze

WORKFLOW_STATE = [
  # name a state after an active bottleneck
  {
    # state: 'Requested',
    state: 'Pending Supervisor Review',
    description: 'Initial state which triggers the opening of a purchase request and is pending supervisor review'
  },
  {
    # state: 'Declined',
    state: 'Purchase Request Declined',
    description: 'State indicating that the purchase request has been declined by the supervisor'
  },
  {
    # state: 'Rescinded',
    state: 'Purchase Request Rescinded',
    description: 'State indicating that the purchase request has been rescinded by the owner'
  },
  {
    # state: 'Recalled',
    state: 'Purchase Request Recalled',
    description: 'State indicating that the purchase request has been recalled by the owner'
  },
  {
    # state: 'Approved',
    state: 'Pending Sourcing Quotation',
    description: 'State indicating that the purchase request has been approved by the supervisor and the request has been moved to the finance team for sourcing quotations from vendors' # rubocop:disable Layout/LineLength
  },
  # after supervisor approval, sourcing quotation should direct the method to use for purchasing: IPC or LPO
  {
    state: 'Pending IPC',
    description: 'State indicating that the items estimated or sourced price will require the internal committee to select a vendor' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending LPO',
    description: 'State indicating that the sourced quotations do not exceed the threshold and items can be procured using the LPO document' # rubocop:disable Layout/LineLength
  }

].freeze

WORKFLOW_STATE_TRANSITIONS = [
  # on requested/pending
  # by supervisor
  {
    workflow_state_id: 'Pending Supervisor Review',
    next_state: 'Pending Sourcing Quotation',
    action: 'Approve Purchase Request',
    by_owner: false,
    by_supervisor: true
  },
  {
    workflow_state_id: 'Pending Supervisor Review',
    next_state: 'Purchase Request Declined',
    action: 'Decline Purchase Request',
    by_owner: false,
    by_supervisor: true
  },
  # by owner
  {
    workflow_state_id: 'Pending Supervisor Review',
    next_state: 'Purchase Request Rescinded',
    action: 'Rescind Purchase Request',
    by_owner: true,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Supervisor Review',
    next_state: 'Purchase Request Recalled',
    action: 'Recall Purchase Request',
    by_owner: true,
    by_supervisor: false
  },
  # on recalled
  # by owner
  {
    workflow_state_id: 'Purchase Request Recalled',
    next_state: 'Pending Supervisor Review',
    action: 'Resubmit Purchase Request',
    by_owner: true,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Purchase Request Recalled',
    next_state: 'Purchase Request Rescinded',
    action: 'Rescind Purchase Request',
    by_owner: true,
    by_supervisor: false
  },
  # on pending sourcing qoutation
  {
    workflow_state_id: 'Pending Sourcing Quotation',
    next_state: 'Pending IPC',
    action: 'Route to IPC',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Sourcing Quotation',
    next_state: 'Pending LPO',
    action: 'Route to LPO',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Sourcing Quotation',
    next_state: 'Purchase Request Declined',
    action: 'Mark Sourcing as Failed',
    by_owner: false,
    by_supervisor: false
  }
].freeze

# TODO: add to workflow_state_actors
WORKFLOW_STATE_TRANSITIONS_ACTORS = [
  {
    state_to_act_on: 'Pending Sourcing Quotation',
    designations: [
      'Director of Finance and Administration',
      'Finance & Administration Lead',
      'Finance Lead',
      'Administration Lead',
      'Finance Officer'
    ]
  }
]

def _get_workflow_process_id(workflow_process_name)
  WorkflowProcess.find_by(workflow: workflow_process_name)&.workflow_process_id
end

def _get_workflow_state_id(process_id, state_name)
  WorkflowState.find_by(
    workflow_process_id: process_id,
    state: state_name
  )&.workflow_state_id
end

# workflow state actors
def _get_designation_role_id(designated_role)
  Designation.find_by(
    designated_role:,
    is_active: true
  )&.designation_id
end

ActiveRecord::Base.transaction do # rubocop:disable Metrics/BlockLength
  # Reset PK sequence
  ActiveRecord::Base.connection.reset_pk_sequence!('workflow_states')
  ActiveRecord::Base.connection.reset_pk_sequence!('workflow_processes')
  ActiveRecord::Base.connection.reset_pk_sequence!('workflow_state_transitions')

  # 1. Upsert Workflow Process
  process = WorkflowProcess.find_or_create_by!(workflow: WORKFLOW_PROCESS[:workflow]) do |wp|
    wp.active = WORKFLOW_PROCESS[:active]
  end

  process_id = process.workflow_process_id

  # 2. Upsert States (preserves existing IDs)
  WORKFLOW_STATE.each do |state_data|
    state = WorkflowState.find_or_initialize_by(
      workflow_process_id: process_id,
      state: state_data[:state]
    )
    state.update!(description: state_data[:description])
  end

  # 3. Upsert Transitions
  WORKFLOW_STATE_TRANSITIONS.each do |transition_data|
    from_state_id = _get_workflow_state_id(process_id, transition_data[:workflow_state_id])
    to_state_id   = _get_workflow_state_id(process_id, transition_data[:next_state])

    transition = WorkflowStateTransition.find_or_initialize_by(
      workflow_state_id: from_state_id,
      next_state: to_state_id,
      action: transition_data[:action]
    )
    transition.update!(
      by_owner: transition_data[:by_owner],
      by_supervisor: transition_data[:by_supervisor]
    )
  end

  # 4. Upsert Actors
  WORKFLOW_STATE_TRANSITIONS_ACTORS.each do |workflow_state_actor|
    workflow_state_id = _get_workflow_state_id(process_id, workflow_state_actor[:state_to_act_on])
    next unless workflow_state_id

    workflow_state_actor[:designations].each do |designation|
      designation_id = _get_designation_role_id(designation)
      next unless designation_id

      wsa = WorkflowStateActor.find_or_initialize_by(
        workflow_state_id:,
        employee_designation_id: designation_id,
        voided: false
      )

      wsa.update!(
        workflow_state_id:,
        employee_designation_id: designation_id
      )
    end
  end

  # 5. Upsert Initial State
  first_state_id = _get_workflow_state_id(process_id, WORKFLOW_STATE.first[:state])
  initial_state = InitialState.find_or_initialize_by(workflow_process_id: process_id)
  initial_state.update!(workflow_state_id: first_state_id)
end
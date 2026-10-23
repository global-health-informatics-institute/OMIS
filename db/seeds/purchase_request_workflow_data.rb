# frozen_string_literal: true

# seed script for populating the logical workflow

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
    description: 'State indicating that the purchase request has been declined by the supervisor/finance/any authorized person' # rubocop:disable Layout/LineLength
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
  # ON: Pending Sourcing Quotation - after supervisor approval, sourcing quotation should direct the method to use for purchasing: IPC or LPO # rubocop:disable Layout/LineLength
  {
    state: 'Pending IPC - Vendor Analysis',
    description: 'State indicating that the items estimated or sourced price will require the internal committee to select a vendor' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending Vendor Analysis',
    description: 'State indicating that the items estimated or sourced price will require the internal committee to select a vendor' # rubocop:disable Layout/LineLength
  },
  # after a vendor is selected (IPC or vendor analysis), finance decides: LPO or direct purchase
  {
    state: 'Pending LPO Check',
    description: 'State indicating that a vendor has been selected (via IPC or vendor analysis) and finance is checking whether an LPO is required or the item can be bought and paid for directly' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending LPO Request Submission',
    description: 'State indicating that an LPO request is required for the selected vendor and is being reviewed, approved and sent' # rubocop:disable Layout/LineLength
  },
  # ON: Pending LPO Request Submission - requires approval from the finance lead and ED
  {
    state: 'Pending LPO Review - Finance Team',
    description: 'State indicating that the LPO request is being reviewed by the finance team and will be sent to the ED for approval' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending LPO Review - ED',
    description: 'State indicating that the LPO request is being reviewed by the Executive Director and will be approved or rejected' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending Delivery Confirmation',
    description: 'State indicating that the LPO was sent and finance is waiting to confirm item delivery and the delivery note' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Item Delivery Failed',
    description: 'State indicating that the supplier did not deliver the item within the required timeframe'
  },
  {
    # on item rejection: reroutes to pending delivery
    state: 'Pending Item Acceptance',
    description: 'State indicating that delivery was confirmed and the purchase request owner must accept or decline the item' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending Payment Request',
    description: 'State indicating that a vendor was selected and the item was either accepted (LPO path) or can be paid for directly, so a payment request can be prepared' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending Payment Request Review - Finance Team',
    description: 'State indicating that the payment request is being reviewed by the finance team and will be sent to the ED for approval' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending Payment Request Review - ED',
    description: 'State indicating that the payment request is being reviewed by the Executive Director and will be approved or rejected' # rubocop:disable Layout/LineLength
  },
  {
    state: 'Pending Payment Voucher',
    description: 'State indicating that the payment request has been approved by the ED and a payment voucher is pending' # rubocop:disable Layout/LineLength
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
  # by finance team

  # extra qoutation on 500K value does not triger further step
  # 3M cap does not trigger a new step so available options are IPC, vendor analysis, and purchase request termination

  {
    workflow_state_id: 'Pending Sourcing Quotation',
    next_state: 'Pending IPC - Vendor Analysis',
    action: 'Route to IPC - Vendor Analysis',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Sourcing Quotation',
    next_state: 'Pending Vendor Analysis',
    action: 'Forward to Vendor Analysis',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Sourcing Quotation',
    next_state: 'Purchase Request Declined',
    action: 'Mark Sourcing as Failed',
    by_owner: false,
    by_supervisor: false
  },
  # on Pending IPC - Vendor Analysis
  # by finance team
  {
    # alias for pending vendor analysis
    workflow_state_id: 'Pending IPC - Vendor Analysis',
    next_state: 'Pending LPO Check',
    action: 'Save Qoutation',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending IPC - Vendor Analysis',
    next_state: 'Purchase Request Declined',
    action: 'Mark Sourcing as Failed',
    by_owner: false,
    by_supervisor: false
  },

  # Pending vendor analysis
  # by finance team
  {
    workflow_state_id: 'Pending Vendor Analysis',
    next_state: 'Pending LPO Check',
    action: 'Save Qoutation',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Vendor Analysis',
    next_state: 'Purchase Request Declined',
    action: 'Mark Sourcing as Failed',
    by_owner: false,
    by_supervisor: false
  },
  # on Pending LPO Check (vendor already selected)
  # by finance team
  {
    workflow_state_id: 'Pending LPO Check',
    next_state: 'Pending LPO Request Submission',
    action: 'Route to LPO Request',
    by_owner: false,
    by_supervisor: false
  },
  {
    # direct purchase: no LPO, the item is bought and paid for directly
    workflow_state_id: 'Pending LPO Check',
    next_state: 'Pending Payment Request',
    action: 'Forward to Payment Request',
    by_owner: false,
    by_supervisor: false
  },

  # on Pending LPO Request Submission
  # by finance team (review -> finance lead -> download LPO)
  {
    workflow_state_id: 'Pending LPO Request Submission',
    next_state: 'Pending LPO Review - Finance Team',
    action: 'Prepare LPO Request',
    by_owner: false,
    by_supervisor: false
  },

  # on Pending LPO Review - Finance Team
  {
    workflow_state_id: 'Pending LPO Review - Finance Team',
    next_state: 'Pending LPO Review - ED',
    action: 'Approve LPO Request',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending LPO Review - Finance Team',
    next_state: 'Pending Sourcing Quotation',
    action: 'Choose Other Vendor',
    by_owner: false,
    by_supervisor: false
  },

  # on Pending LPO Review - ED
  {
    workflow_state_id: 'Pending LPO Review - ED',
    next_state: 'Pending Delivery Confirmation',
    action: 'Approve LPO Request',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending LPO Review - ED',
    next_state: 'Pending Sourcing Quotation',
    action: 'Choose Other Vendor',
    by_owner: false,
    by_supervisor: false
  },

  # on Pending Delivery Confirmation
  # by finance team
  {
    workflow_state_id: 'Pending Delivery Confirmation',
    next_state: 'Pending Item Acceptance',
    action: 'Confirm Delivery',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Delivery Confirmation',
    next_state: 'Item Delivery Failed',
    action: 'Mark Delivery as Failed',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Delivery Confirmation',
    next_state: 'Pending Sourcing Quotation',
    action: 'Choose Other Vendor',
    by_owner: false,
    by_supervisor: false
  },

  # on Pending Item Acceptance
  # by owner (PR initiator)
  {
    workflow_state_id: 'Pending Item Acceptance',
    next_state: 'Pending Payment Request',
    action: 'Accept Item',
    by_owner: true,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Item Acceptance',
    next_state: 'Pending Delivery Confirmation',
    action: 'Decline Item',
    by_owner: true,
    by_supervisor: false
  },

  # on Pending Payment Request
  # by finance team
  {
    workflow_state_id: 'Pending Payment Request',
    next_state: 'Pending Payment Request Review - Finance Team',
    action: 'Prepare Payment Request',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Payment Request',
    next_state: 'Purchase Request Declined',
    action: 'Terminate Payment Request',
    by_owner: false,
    by_supervisor: false
  },

  # on Pending Payment Request Review - Finance Team
  # by finance team
  {
    workflow_state_id: 'Pending Payment Request Review - Finance Team',
    next_state: 'Pending Payment Request Review - ED',
    action: 'Approve Payment Request',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Payment Request Review - Finance Team',
    next_state: 'Purchase Request Declined',
    action: 'Terminate Payment Request',
    by_owner: false,
    by_supervisor: false
  },

  # on Pending Payment Request Review - ED
  # by ED
  {
    workflow_state_id: 'Pending Payment Request Review - ED',
    next_state: 'Pending Payment Voucher',
    action: 'Approve Payment Request',
    by_owner: false,
    by_supervisor: false
  },
  {
    workflow_state_id: 'Pending Payment Request Review - ED',
    next_state: 'Purchase Request Declined',
    action: 'Terminate Payment Request',
    by_owner: false,
    by_supervisor: false
  }
].freeze

# TODO: add to workflow_state_actors
FT_DESIGNATIONS = [
  'Director of Finance and Administration',
  'Finance & Administration Lead',
  'Finance Lead',
  'Administration Lead',
  'Finance Officer',
  'Receptionist'
].freeze

FT_STATES = [
  'Pending Sourcing Quotation',
  'Pending IPC - Vendor Analysis',
  'Pending Vendor Analysis',
  'Pending LPO Check',
  'Pending Delivery Confirmation'
].freeze

# who can act on the review states
JNR_FT_DESIGNATION = [
  'Administration Lead',
  'Finance Officer',
  'Receptionist'
].freeze

JNR_FT_STATES = [
  'Pending LPO Request Submission',
  'Pending Payment Request',
  'Pending Payment Voucher'
].freeze

SNR_FT_DESIGNATION = [
  'Director of Finance and Administration',
  'Finance & Administration Lead',
  'Finance Lead'
].freeze

SNR_FT_STATES = [
  'Pending LPO Review - Finance Team',
  'Pending Payment Request Review - Finance Team'
].freeze

ED_DESIGNATION = [
  'Director'
].freeze

ED_STATES = [
  'Pending LPO Review - ED',
  'Pending Payment Request Review - ED'
].freeze

# states the finance team acts on, plus the review states
# (Pending Item Acceptance is acted on by the request owner, so it has no actors)
WORKFLOW_STATE_TRANSITIONS_ACTORS = (
  FT_STATES.map { |state| { state_to_act_on: state, designations: FT_DESIGNATIONS } } +
  JNR_FT_STATES.map { |state| { state_to_act_on: state, designations: JNR_FT_DESIGNATION } } +
  SNR_FT_STATES.map { |state| { state_to_act_on: state, designations: SNR_FT_DESIGNATION } } +
  ED_STATES.map { |state| { state_to_act_on: state, designations: ED_DESIGNATION } }
).freeze

# every state with a "Prepare ..." action must be a junior FT state
prepare_states = WORKFLOW_STATE_TRANSITIONS.select { |t| t[:action].start_with?('Prepare') }
                                           .map { |t| t[:workflow_state_id] }.uniq
not_junior = prepare_states - JNR_FT_STATES
unless not_junior.empty?
  raise "Prepare actions must come from junior FT states, but these are not in JNR_FT_STATES: #{not_junior.join(', ')}"
end

# a state must be in only one actor group, otherwise it collects the designations of every group it is in
duplicate_states = WORKFLOW_STATE_TRANSITIONS_ACTORS.map { |a| a[:state_to_act_on] }.tally.select { |_, n| n > 1 }.keys
raise "State listed in more than one actor group: #{duplicate_states.join(', ')}" unless duplicate_states.empty?

# IPC threshhold
GLOBAL_PROPERTIES = [
  {
    property: 'IPC threshold',
    property_value: '3000000',
    description: 'The IPC threshold cap is the maximum amount that can be approved for procurement without requiring an (IPC) review.' # rubocop:disable Layout/LineLength
  },
  {
    property: 'Levy rate',
    property_value: '0.05',
    description: 'Current levy rate for all purchases, expressed as a decimal. For example, a 5% levy rate is represented as 0.05.' # rubocop:disable Layout/LineLength
  },
  {
    property: 'MRA rate',
    property_value: '17.5',
    description: 'Current MRA rate for all purchases, expressed as a percentage. For example, a 17.5% MRA rate is represented as 17.5.' # rubocop:disable Layout/LineLength
  },
  {
    property: 'LPO validity period (days)',
    property_value: '7',
    description: 'The number of days an LPO is valid for after it has been issued. After this period, the LPO will expire and may require re-issuance or renewal.' # rubocop:disable Layout/LineLength
  },
  {
    property: 'Office Address',
    property_value: 'GHIII Offices, area 3/719',
    description: 'The address of the office where purchases are managed.'
  }
].freeze

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

# DRY_RUN=1 runs everything inside the transaction, prints the counts, then rolls back
dry_run = ENV['DRY_RUN'] == '1'

# counts for the summary printed at the end
stats = {
  states: { created: 0, updated: 0 },
  transitions: { created: 0, updated: 0 },
  actors: { created: 0, updated: 0, skipped: 0 },
  global_properties: { created: 0, updated: 0 },
  stale: {}
}
touched = { states: [], transitions: [] }

puts dry_run ? 'Previewing Purchase Request workflow (DRY_RUN)' : 'Seeding Purchase Request workflow'

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
    stats[:states][state.new_record? ? :created : :updated] += 1
    state.update!(description: state_data[:description])
    touched[:states] << state.workflow_state_id
  end

  # 3. Upsert Transitions
  WORKFLOW_STATE_TRANSITIONS.each do |transition_data|
    from_state_id = _get_workflow_state_id(process_id, transition_data[:workflow_state_id])
    to_state_id   = _get_workflow_state_id(process_id, transition_data[:next_state])

    # fail loudly on a state name typo instead of inserting a row with a nil id
    unless from_state_id && to_state_id
      raise "Unknown state in transition '#{transition_data[:action]}': " \
            "#{transition_data[:workflow_state_id]} -> #{transition_data[:next_state]}"
    end

    transition = WorkflowStateTransition.find_or_initialize_by(
      workflow_state_id: from_state_id,
      next_state: to_state_id,
      action: transition_data[:action]
    )
    stats[:transitions][transition.new_record? ? :created : :updated] += 1
    transition.update!(
      by_owner: transition_data[:by_owner],
      by_supervisor: transition_data[:by_supervisor]
    )
    touched[:transitions] << [from_state_id, to_state_id, transition_data[:action]]
  end

  # 4. Upsert Actors
  WORKFLOW_STATE_TRANSITIONS_ACTORS.each do |workflow_state_actor|
    workflow_state_id = _get_workflow_state_id(process_id, workflow_state_actor[:state_to_act_on])
    raise "Unknown state in actors: #{workflow_state_actor[:state_to_act_on]}" unless workflow_state_id

    workflow_state_actor[:designations].each do |designation|
      designation_id = _get_designation_role_id(designation)
      unless designation_id
        warn "Designation not found (skipped): '#{designation}' for '#{workflow_state_actor[:state_to_act_on]}'"
        stats[:actors][:skipped] += 1
        next
      end

      wsa = WorkflowStateActor.find_or_initialize_by(
        workflow_state_id:,
        employee_designation_id: designation_id,
        voided: false
      )

      stats[:actors][wsa.new_record? ? :created : :updated] += 1
      wsa.update!(
        workflow_state_id:,
        employee_designation_id: designation_id
      )
    end
  end

  # 5. Upsert Global Properties
  GLOBAL_PROPERTIES.each do |global_property|
    gp = GlobalProperty.find_or_initialize_by(
      global_property
    )

    stats[:global_properties][gp.new_record? ? :created : :updated] += 1
    gp.update!(
      global_property
    )
  end

  # 6. Upsert Initial State
  first_state_id = _get_workflow_state_id(process_id, WORKFLOW_STATE.first[:state])
  initial_state = InitialState.find_or_initialize_by(workflow_process_id: process_id)
  initial_state.update!(workflow_state_id: first_state_id)

  # 7. Find rows from earlier runs that are no longer in this seed (reported, never deleted)
  state_names = WorkflowState.where(workflow_process_id: process_id).pluck(:workflow_state_id, :state).to_h
  stats[:stale][:states] = state_names.reject { |id, _| touched[:states].include?(id) }.values
  stats[:stale][:transitions] =
    WorkflowStateTransition.where(workflow_state_id: state_names.keys).filter_map do |t|
      next if touched[:transitions].include?([t.workflow_state_id, t.next_state, t.action])

      "#{state_names[t.workflow_state_id]} -> #{state_names[t.next_state]} (#{t.action})"
    end

  raise ActiveRecord::Rollback if dry_run
end

# summary (not reached if anything above raised)
format_counts = lambda do |counts|
  "#{counts[:created] + counts[:updated]} (#{counts[:created]} new, #{counts[:updated]} existing)"
end

puts(dry_run ? 'DRY RUN - nothing was saved. A real run would do this:' : 'Completed seeding Purchase Request workflow:')
puts "  States:            #{format_counts.call(stats[:states])}"
puts "  Transitions:       #{format_counts.call(stats[:transitions])}"
puts "  Actors:            #{format_counts.call(stats[:actors])}, #{stats[:actors][:skipped]} designation(s) not found"
puts "  Global properties: #{format_counts.call(stats[:global_properties])}"

unless stats[:stale][:states].empty? && stats[:stale][:transitions].empty?
  puts '  Left over from earlier runs (not in this seed, not deleted):'
  stats[:stale][:states].each { |name| puts "    state: #{name}" }
  stats[:stale][:transitions].each { |label| puts "    transition: #{label}" }
end
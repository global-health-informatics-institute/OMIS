# frozen_string_literal: true
# bundle exec rails runner 'load "db/seeds/petty_cash_transitions_and_states.rb"'

  liquidate_funds_workflow_state_transition = WorkflowStateTransition.find_by(action: 'Liquidate Funds')
  disburse_funds_workflow_state_transition= WorkflowStateTransition.find_by(action: 'Disburse Funds')
  liquidated_workflow_state = WorkflowState.find_by(workflow_state_id: 36)
  purchase_request_workflow_process = WorkflowProcess.find_by(workflow: 'Purchase Request')
  approve_purchase_request_workflow_state_transition = WorkflowStateTransition.find_by(action: 'Approve Purchase Request')
  requested_purchase_request_workflow_state = WorkflowState.find_by(workflow_state_id: 37)
  approved_purchase_request_workflow_state = WorkflowState.find_by(workflow_state_id: 38)
ActiveRecord::Base.transaction do

  if liquidated_workflow_state.nil?
    WorkflowState.create(
      workflow_state_id: 36,
      workflow_process_id: 4,
      state: 'Liquidated',
      description: 'Petty cash funds have been liquidated',
      voided: false
    )
  end
  if requested_purchase_request_workflow_state.nil?
    WorkflowState.create(
      workflow_state_id: 37,
      workflow_process_id: 6,
      state: 'Requested',
      description: 'Purchase request has been initiated',
      voided: false
    )
  end
  if approved_purchase_request_workflow_state.nil?
    WorkflowState.create(
      workflow_state_id: 38,
      workflow_process_id: 6,
      state: 'Approved',
      description: 'Purchase request has been approved',
      voided: false
    )
  end
  if purchase_request_workflow_process.nil?
    WorkflowProcess.create(
      workflow_process_id: 6,
      workflow: 'Purchase Request',
      active: true
    )
  end
  if liquidate_funds_workflow_state_transition.nil?
    last_id = WorkflowStateTransition.maximum(:id) || 0
    WorkflowStateTransition.create(
      id: last_id + 1,
      workflow_state_id: 29,
      next_state: 36,
      voided: false,
      action: 'Liquidate Funds',
      by_owner: false,
      by_supervisor: false
    )
  end
  if disburse_funds_workflow_state_transition.nil?
    last_id = WorkflowStateTransition.maximum(:id) || 0
    WorkflowStateTransition.create(
      id: last_id + 1,
      workflow_state_id: 28,
      next_state: 29,
      voided: false,
      action: 'Disburse Funds',
      by_owner: false,
      by_supervisor: false
    )
  end
   if approve_purchase_request_workflow_state_transition.nil?
    last_id = WorkflowStateTransition.maximum(:id) || 0
    WorkflowStateTransition.create(
      id: last_id + 1,
      workflow_state_id: 37,
      next_state: 38,
      voided: false,
      action: 'Approve Purchase Request',
      by_owner: false,
      by_supervisor: true
    )
  end
end

# frozen_string_literal: true

  liquidate_funds_workflow_state_transition = WorkflowStateTransition.find_by(action: 'Liquidate Funds')
  disburse_funds_workflow_state_transition= WorkflowStateTransition.find_by(action: 'Disburse Funds')
  liquidated_workflow_state = WorkflowState.find_by(workflow_state_id: 36)
# bundle exec rails runner 'load "db/seeds/petty_cash_transitions_and_states.rb"'
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
end

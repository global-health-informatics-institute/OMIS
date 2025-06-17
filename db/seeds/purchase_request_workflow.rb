# frozen_string_literal: true

# bundle exec rails runner 'load "db/seeds/purchase_request_workflow.rb"'

purchase_request_workflow_process = WorkflowProcess.find_by(workflow: 'Purchase Request')
approve_purchase_request_workflow_state_transition = WorkflowStateTransition.find_by(next_state: 38)
requested_purchase_request_workflow_state = WorkflowState.find_by(workflow_state_id: 37)
approved_purchase_request_workflow_state = WorkflowState.find_by(workflow_state_id: 38)
initial_state_purchase_request = InitialState.find_by(workflow_process_id: 6)
admin_designation_workflow_state_actor = WorkflowStateActor.find_by(workflow_state_id: 38)
rejected_state_purchase_request = WorkflowState.find_by(workflow_state_id:39)
reject_purchase_request_workflow_state_transition = WorkflowStateTransition.find_by(next_state: 39)
under_procurement_workflow_state = WorkflowState.find_by(workflow_state_id: 40)
start_procurement_workflow_state_transition = WorkflowStateTransition.find_by(next_state: 40)
complete_procurement_workflow_state_transition = WorkflowStateTransition.find_by(next_state: 41)
procured_purchase_request_workflow_state = WorkflowState.find_by(workflow_state_id: 41)
admin_designation_under_procurement_workflow_state_actor = WorkflowStateActor.find_by(workflow_state_id: 40)
threshold_purchase_request_global_properties = GlobalProperty.find_by(property: 'purchase.request.threshold')

ActiveRecord::Base.transaction do
  if initial_state_purchase_request.nil?
    InitialState.create(
      workflow_process_id: 6,
      workflow_state_id: 37
    )
  end
  # global_property
  if threshold_purchase_request_global_properties.nil?
    GlobalProperty.create(
      property: 'purchase.request.threshold',
      property_value: 3000000,
      description: 'Allocated threshold for purchase request that trigger internal procurement committee review'
    )
  end
  # workflow_state_model
  if requested_purchase_request_workflow_state.nil?
    WorkflowState.create(
      workflow_state_id: 37,
      workflow_process_id: 6,
      state: 'Requested',
      description: 'Purchase request has been initiated',
      voided: false
    )
  end
  if under_procurement_workflow_state.nil?
    WorkflowState.create(
      workflow_state_id: 40,
      workflow_process_id: 6,
      state: 'Under Procurement',
      description: 'Purchase request is under procurement',
      voided: false
    )
  end
  if rejected_state_purchase_request.nil?
    WorkflowState.create(
      workflow_state_id: 39,
      workflow_process_id: 6,
      state: 'Rejected',
      description:'State where purchase request has rejected',
      voided: false
    )
  end
  if procured_purchase_request_workflow_state.nil?
    WorkflowState.create(
      workflow_state_id: 41,
      workflow_process_id: 6,
      state: 'Procured',
      description: 'Purchase request has been procured',
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
  # workflow_state_actors_model
  if admin_designation_workflow_state_actor.nil?
    WorkflowStateActor.create(
      workflow_state_id:38,
      employee_designation_id:12,
      voided: false
    )
  end
  if admin_designation_under_procurement_workflow_state_actor.nil?
    WorkflowStateActor.create(
      workflow_state_id: 40,
      employee_designation_id: 12,
      voided: false
    )
  end
  # workflow_state_transitions_model
  if purchase_request_workflow_process.nil?
    WorkflowProcess.create(
      workflow_process_id: 6,
      workflow: 'Purchase Request',
      active: true
    )
  end
  if approve_purchase_request_workflow_state_transition.nil?
    last_id = WorkflowStateTransition.maximum(:id) || 0
    WorkflowStateTransition.create(
      id: last_id + 1,
      workflow_state_id: 37,
      next_state: 38,
      voided: false,
      action: 'Approve Request',
      by_owner: false,
      by_supervisor: true
    )
  end
  if reject_purchase_request_workflow_state_transition.nil?
    last_id = WorkflowStateTransition.maximum(:id) || 0
    WorkflowStateTransition.create(
       id: last_id + 1,
      workflow_state_id: 37,
      next_state: 39,
      voided: false,
      action: 'Reject Request',
      by_owner: false,
      by_supervisor: true
    )
  end
  if start_procurement_workflow_state_transition.nil?
    last_id = WorkflowStateTransition.maximum(:id) || 0
    WorkflowStateTransition.create(
      id: last_id + 1,
      workflow_state_id: 38,
      next_state: 40,
      voided: false,
      action: 'Start Procurement',
      by_owner: false,
      by_supervisor: false
    )
  end
  if complete_procurement_workflow_state_transition.nil?
    last_id = WorkflowStateTransition.maximum(:id) || 0
    WorkflowStateTransition.create(
      id: last_id + 1,
      workflow_state_id: 40,
      next_state: 41,
      voided: false,
      action: 'Complete Procurement',
      by_owner: false,
      by_supervisor: false
    )
  end
end

# frozen_string_literal: true

class PurchaseRequestPendingActionsService # rubocop:disable Style/Documentation
  TERMINAL_STATES = [
    'Purchase Request Recalled',
    'Purchase Request Rescinded',
    'Purchase Request Declined',
    'Purchase Request Complete'
  ].freeze

  class << self
    def for(employee)
      new(employee).call
    end
  end

  def initialize(employee)
    @employee = employee
  end

  def call
    purchase_requests.where(requisition_id: pending_request_ids).order(created_at: :desc).map do |purchase_request|
      [
        "Review purchase request for #{purchase_request.purpose}",
        "/requisitions/purchase_requests/#{purchase_request.requisition_id}",
        'purchase_requests'
      ]
    end
  end

  private

  attr_reader :employee

  def pending_request_ids
    actor_request_ids | requester_request_ids
  end

  def actor_request_ids
    designation_request_ids | supervisor_request_ids
  end

  def designation_request_ids
    state_ids = WorkflowStateActor.where(
      employee_designation_id: employee.current_designations.pluck(:designation_id)
    ).pluck(:workflow_state_id)

    purchase_requests.where(workflow_state_id: state_ids).pluck(:requisition_id)
  end

  def supervisor_request_ids
    supervisee_ids = employee.current_supervisees.pluck(:supervisee)
    return [] if supervisee_ids.empty?

    supervisor_state_ids = WorkflowStateTransition.where(by_supervisor: true).pluck(:workflow_state_id)
    purchase_requests.where(initiated_by: supervisee_ids, workflow_state_id: supervisor_state_ids)
                     .pluck(:requisition_id)
  end

  def requester_request_ids
    purchase_requests.joins(:workflow_state)
                     .where(initiated_by: employee.id)
                     .where.not(workflow_states: { state: TERMINAL_STATES })
                     .pluck(:requisition_id)
  end

  def purchase_requests
    @purchase_requests ||= PurchaseRequest.where(requisition_type: 'Purchase Request')
  end
end

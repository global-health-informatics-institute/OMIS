# frozen_string_literal: true

class PurchaseRequest < Requisition # rubocop:disable Style/Documentation
  IPC_WORKFLOW_STATES = [
    'Pending Vendor Shortlisting - IPC',
    'Pending Price Entry - IPC',
    'Pending Vendor Selection - IPC'
  ].freeze

  has_one :purchase_request_detail,
          foreign_key: :requisition_id,
          primary_key: :requisition_id,
          dependent: :delete,
          autosave: true
  has_one :requisition_donor, foreign_key: :requisition_id, dependent: :delete
  has_many :committee_meetings, foreign_key: :requisition_id, primary_key: :requisition_id,
                                dependent: :restrict_with_error

  belongs_to :initiator, class_name: 'Employee', foreign_key: 'initiated_by', optional: true
  belongs_to :approver,  class_name: 'Employee', foreign_key: 'approved_by',  optional: true
  belongs_to :reviewer,  class_name: 'Employee', foreign_key: 'reviewed_by',  optional: true

  accepts_nested_attributes_for :purchase_request_detail
  accepts_nested_attributes_for :requisition_donor

  delegate :approved_on, :approved_on=,
           :reviewed_on, :reviewed_on=,
           :vendor_name, :vendor_name=,
           to: :purchase_request_detail, allow_nil: true

  # convenience methods for full names
  def initiated_by_full_name
    initiator&.person&.full_name
  end

  def approved_by_full_name
    approver&.person&.full_name
  end

  def reviewed_by_full_name
    # tracks name of the last person to act on the requisition
    reviewer&.person&.full_name
  end

  def purchase_request_detail
    super || build_purchase_request_detail
  end

  # TODO: move to refactored 'posible_actions'
  def available_actions(user:, is_owner: false, is_supervisor: false, owner_only: false, acting_employees: []) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    state_id = workflow_state_id
    return [] unless state_id

    actions = []

    actions += WorkflowStateTransition.where(workflow_state_id: state_id, by_owner: true).pluck(:action) if is_owner
    return actions.compact.uniq if owner_only

    if is_supervisor
      actions += WorkflowStateTransition.where(workflow_state_id: state_id,
                                               by_supervisor: true).pluck(:action)
    end

    # TODO: Correct misleading field 'employee_designation_id' to 'designation_id' in the WorkflowStateTransition model
    # because the field is actually referencing the Designation model, not the EmployeeDesignation model.
    is_actor = if ipc_workflow_state?
                 ipc_committee_member?(user)
               else
                 WorkflowStateActor.where(
                   employee_designation_id: action_designation_ids(user, acting_employees), # TODO: migrate to reflect designation role not a specific employee role entry # rubocop:disable Layout/LineLength
                   workflow_state_id: state_id
                 ).exists?
               end

    if is_actor
      actions += WorkflowStateTransition.where(
        workflow_state_id: state_id,
        by_owner: false,
        by_supervisor: false
      ).pluck(:action)
    end

    actions.compact.uniq
  end

  def requester?(user)
    return false unless user && initiated_by

    [user.employee_id, user.employee&.employee_id, user.id].compact.include?(initiated_by)
  end

  def actor?(user)
    return ipc_committee_member?(user) if ipc_workflow_state?

    WorkflowStateActor.exists?(
      employee_designation_id: action_designation_ids(user, acting_employees_for(user)),
      workflow_state_id: workflow_state_id
    )
  end

  def core_editable_by?(user)
    return false unless user

    is_owner = requester?(user)

    ['purchase request recalled', 'purchase request rejected'].include?(current_state.to_s.downcase) && is_owner
  end

  def sourcing_qoutations_editable_by?(user)
    return false unless user

    [
      'pending vendor analysis - single quotation',
      'pending price entry - ipc',
      'pending price entry - multiple quotation'
    ].include?(current_state.to_s.downcase) && actor?(user)
  end

  def ipc_workflow_state?
    current_state.in?(IPC_WORKFLOW_STATES)
  end

  def editable_by?(user)
    core_editable_by?(user) || sourcing_qoutations_editable_by?(user)
  end

  # TODO: Move to GlobalProperty model
  def self.ipc_threshold
    GlobalProperty.find_by(
      property: 'ipc.threshold'
    )&.property_value.to_i
  end

  private

  def acting_employees_for(user)
    employee = user&.employee
    return [] unless employee

    [employee, *employee.active_leave_stand_ins].uniq(&:employee_id)
  end

  def action_designation_ids(user, acting_employees)
    employees = [user&.employee, *acting_employees].compact.uniq(&:employee_id)
    employees.flat_map { |employee| employee.current_designations.pluck(:designation_id) }.uniq
  end

  def ipc_committee_member?(user)
    employee_ids = [user&.employee_id, user&.employee&.employee_id, user&.id].compact
    return false if employee_ids.empty?

    committee_meetings.scheduled.order(scheduled_on: :desc).first
                      &.committee
                      &.active_memberships
                      &.where(employee_id: employee_ids)
                      &.exists? || false
  end
end

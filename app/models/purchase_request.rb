# frozen_string_literal: true

class PurchaseRequest < Requisition # rubocop:disable Style/Documentation
  has_one :purchase_request_detail, foreign_key: :requisition_id, primary_key: :requisition_id, dependent: :delete
  has_one :requisition_budget_line, foreign_key: :requisition_id, dependent: :delete
  has_one :requisition_donor, foreign_key: :requisition_id, dependent: :delete

  belongs_to :initiator, class_name: 'Employee', foreign_key: 'initiated_by', optional: true
  belongs_to :approver,  class_name: 'Employee', foreign_key: 'approved_by',  optional: true
  belongs_to :reviewer,  class_name: 'Employee', foreign_key: 'reviewed_by',  optional: true

  accepts_nested_attributes_for :purchase_request_detail
  accepts_nested_attributes_for :requisition_budget_line
  accepts_nested_attributes_for :requisition_donor

  delegate :approved_on, :approved_on=, :reviewed_on, :reviewed_on=, to: :purchase_request_detail, allow_nil: true

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
  def available_actions(user:, is_owner: false, is_supervisor: false) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    state_id = workflow_state_id
    return [] unless state_id

    actions = []

    actions += WorkflowStateTransition.where(workflow_state_id: state_id, by_owner: true).pluck(:action) if is_owner

    if is_supervisor
      actions += WorkflowStateTransition.where(workflow_state_id: state_id,
                                               by_supervisor: true).pluck(:action)
    end

    # role/designation based priledges - Specific actions are available based on your current office
    # TODO: Correct misleading field 'employee_designation_id' to 'designation_id' in the WorkflowStateTransition model
    # because the field is actually referencing the Designation model, not the EmployeeDesignation model.
    designation_id = user&.employee&.employee_designations&.last&.designation_id

    is_actor = WorkflowStateActor.where(
      employee_designation_id: designation_id, # TODO: migrate to reflect designation role not a specific employee role entry # rubocop:disable Layout/LineLength
      workflow_state_id: state_id
    ).exists?

    if is_actor
      actions += WorkflowStateTransition.where(
        workflow_state_id: state_id,
        by_owner: false,
        by_supervisor: false
      ).pluck(:action)
    end

    actions.compact.uniq
  end

  def editable_by?(user)
    return false unless user

    is_owner = initiated_by == user&.employee&.id || initiated_by == user&.id

    case current_state.to_s.downcase
    when 'purchase request recalled', 'purchase request rejected'
      is_owner
    else
      false
    end
  end
end

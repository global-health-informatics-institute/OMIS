# frozen_string_literal: true

class PurchaseRequest < Requisition # rubocop:disable Style/Documentation
  has_one :purchase_request_detail, foreign_key: :requisition_id, dependent: :delete
  has_one :requisition_budget_line, foreign_key: :requisition_id, dependent: :delete
  has_one :requisition_donor, foreign_key: :requisition_id, dependent: :delete

  accepts_nested_attributes_for :purchase_request_detail
  accepts_nested_attributes_for :requisition_budget_line
  accepts_nested_attributes_for :requisition_donor

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

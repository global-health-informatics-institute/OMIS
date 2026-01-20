class Requisition < ApplicationRecord
  belongs_to :user, foreign_key: :initiated_by
  # belongs_to :project, foreign_key: :project_id
  # the project to be option
  belongs_to :project, foreign_key: :project_id, optional: true
  belongs_to :department, foreign_key: :department_id, optional: true

  has_one :purchase_request_attachment, foreign_key: :requisition_id
  has_many :requisition_items, foreign_key: :requisition_id
  has_many :requisition_notes, foreign_key: :requisition_id
  has_many :petty_cash_comments, foreign_key: :requisition_id
  belongs_to :workflow_state, foreign_key: :workflow_state_id, primary_key: :workflow_state_id, optional: true
  has_and_belongs_to_many :employees
  has_many_attached :attachments
  has_many :assets, foreign_key: :requisition_id
  # belongs_to :stakeholder

  def assign_state
    process = WorkflowProcess.find_by(workflow: requisition_type)
    self.workflow_state_id = InitialState.find_by(workflow_process_id: process&.id)&.workflow_state_id
  end

  default_scope { where(voided: false) }

  def current_state
    WorkflowState.find(workflow_state_id).state
  rescue StandardError
    ''

    # self.workflow_state.state rescue status
  end

  def approver
    Employee.find(approved_by).person.full_name
  rescue StandardError
    nil
    # Handle potential nil value
  end

  def recalled?
    WorkflowState.find_by(workflow_state_id: workflow_state_id)&.state == 'Recalled'
  end

  def reviewer
    Employee.find(reviewed_by).person.full_name
  rescue StandardError
    nil
    # Handle potential nil value
  end

  def quantity
    return unless requisition_type == 'Purchase Request'

    requisition_items.first.quantity
  end

  def amount
    return unless requisition_type == 'Petty Cash'

    requisition_items.first.value
  end

  def item_description
    return unless requisition_type == 'Purchase Request'

    requisition_items.first.item_description
  end

  def used_amount
    return unless requisition_type == 'Petty Cash'

    petty_cash_comments.first&.used_amount || 'Missing'

    # nil # Or 0, or some default value if not a "Petty Cash" requisition
  end

  def possible_actions
    designation_id = begin
      current_user.employee.employee_designations.first.designation_id
    rescue StandardError
      nil
    end
    return [] unless designation_id

    actions = []
    workflow_state_transitions.each do |transition|
      if transition.workflow_state_actors.any? { |actor| actor.employee_designation.designation_id == designation_id }
        actions << transition.action
      end
    end

    # Special case for "Pending IPC" state
    actions << 'Request Payment' if current_state == 'Pending IPC' && [12, 28, 78].include?(designation_id)
    
    # Filter actions based on IPC status
    if went_through_ipc?
      # IPC flow: remove "Confirm Delivery" action, keep "Confirm Item Delivery"
      actions = actions.reject { |action| action == 'Confirm Delivery' }
    else
      # Non-IPC flow: remove "Confirm Item Delivery" action, keep "Confirm Delivery"
      actions = actions.reject { |action| action == 'Confirm Item Delivery' }
    end

    actions.uniq
  end

  # Check if requisition went through IPC process
  def went_through_ipc?
    # Use the database field to track IPC status
    went_through_ipc || current_state == 'Pending IPC' || workflow_state&.state == 'Funds Approved'
  end

  private
end

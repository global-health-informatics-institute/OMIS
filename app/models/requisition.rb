class Requisition < ApplicationRecord
  belongs_to :user, :foreign_key =>  :initiated_by
  belongs_to :project, foreign_key: :project_id
  has_many :requisition_items, :foreign_key => :requisition_id
  has_many :requisition_notes, :foreign_key => :requisition_id
  has_many :petty_cash_comments, foreign_key: :requisition_id
  belongs_to :workflow_state, foreign_key: :workflow_state_id, primary_key: :workflow_state_id, optional: true
  has_and_belongs_to_many :employees

  has_one :purchase_request_detail, foreign_key: :requisition_id
  accepts_nested_attributes_for :purchase_request_detail
  accepts_nested_attributes_for :requisition_items

  def assign_state
    self.workflow_state_id = InitialState.find_by_workflow_process_id(WorkflowProcess.find_by_workflow('Petty Cash Request')).workflow_state_id
  end
  default_scope { where(voided: false) }

  def current_state
    return WorkflowState.find(self.workflow_state_id).state rescue ''
    #self.workflow_state.state rescue status
  end

  def approver
    Employee.find(self.approved_by).person.full_name rescue nil # Handle potential nil value
  end

  def recalled?
    WorkflowState.find_by(workflow_state_id: workflow_state_id)&.state == 'Recalled'
  end

  def reviewer
    Employee.find(self.reviewed_by).person.full_name rescue nil # Handle potential nil value
  end

  def amount
    if self.requisition_type == "Petty Cash"
      return self.requisition_items.first.value
    end
  end
 def used_amount
    if self.requisition_type == "Petty Cash"
      # This will return nil if petty_cash_comments.first is nil,
      # preventing the error.
      return self.petty_cash_comments.first&.used_amount || 'Missing'
    end
    # nil # Or 0, or some default value if not a "Petty Cash" requisition
  end
  private

  # def generate_approval_token
  #   token = SecureRandom.urlsafe_base64(32)
  #   Rails.logger.info "Requisition Model: Inside generate_approval_token. Token: #{token}"
  #   self.approval_token = token
  #   Rails.logger.info "Requisition Model: After assignment, self.approval_token: #{self.approval_token}"
  # end
  # def generate_rejection_token 
  #   token = SecureRandom.urlsafe_base64(32)
  #   Rails.logger.info "Requisition Model: Inside generate_rejection_token. Token: #{token}"

end
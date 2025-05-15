class Requisition < ApplicationRecord
  before_create :generate_approval_token
  before_create :generate_rejection_token 
  before_create :generate_approval_funds_token
  before_create :generate_deny_funds_token
  belongs_to :user, :foreign_key =>  :initiated_by
  attribute :approval_token, :string
  attribute :rejection_token, :string 
  # belongs_to :approver, class_name: 'User', :foreign_key =>  :approved_by
  belongs_to :project, foreign_key: :project_id
  has_many :requisition_items, :foreign_key => :requisition_id
  has_many :requisition_notes, :foreign_key => :requisition_id
  has_one :workflow_state, :foreign_key => :workflow_state_id
  #validating the reason field if the requisition is rejected
  # validates :reason, presence: { message: "must be provided when rejecting" }, 
  #                    if: :being_rejected?


  def assign_state
    self.workflow_state_id = InitialState.find_by_workflow_process_id(WorkflowProcess.find_by_workflow('Petty Cash Request')).workflow_state_id
  end

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

  private

  def generate_approval_token
    token = SecureRandom.urlsafe_base64(32)
    Rails.logger.info "Requisition Model: Inside generate_approval_token. Token: #{token}"
    self.approval_token = token
    Rails.logger.info "Requisition Model: After assignment, self.approval_token: #{self.approval_token}"
  end
  def generate_rejection_token 
    token = SecureRandom.urlsafe_base64(32)
    Rails.logger.info "Requisition Model: Inside generate_rejection_token. Token: #{token}"
    self.rejection_token = token
    Rails.logger.info "Requisition Model: After assignment, self.rejection_token: #{self.rejection_token}"
  end
  def generate_approval_funds_token
    token = SecureRandom.urlsafe_base64(32)
    Rails.logger.info "Requisition Model: Inside generate_approval_funds_token. Token: #{token}"
    self.approval_funds_token = token
    Rails.logger.info "Requisition Model: After assignment, self.approval_funds_token: #{self.approval_funds_token}"
  end
  def generate_deny_funds_token
    token = SecureRandom.urlsafe_base64(32)
    Rails.logger.info "Requisition Model: Inside generate_deny_funds_token. Token: #{token}"
    self.deny_funds_token = token
    Rails.logger.info "Requisition Model: After assignment, self.deny_funds_token: #{self.deny_funds_token}"
  end
  # def being_rejected?
  #   workflow_state_id_changed? && WorkflowState.find_by(id: workflow_state_id)&.state == "Rejected"
  # end
end
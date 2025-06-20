class Requisition < ApplicationRecord
  belongs_to :user, :foreign_key =>  :initiated_by
  #belongs_to :project, foreign_key: :project_id
  #the project to be option
  belongs_to :project, foreign_key: :project_id, optional: true

  has_one :purchase_request_attachment, foreign_key: :requisition_id
  has_many :requisition_items, :foreign_key => :requisition_id
  has_many :requisition_notes, :foreign_key => :requisition_id
  has_many :petty_cash_comments, foreign_key: :requisition_id
  belongs_to :workflow_state, foreign_key: :workflow_state_id, primary_key: :workflow_state_id, optional: true
  has_and_belongs_to_many :employees
  has_many_attached :attachments
  #belongs_to :stakeholder

  def assign_state
  process = WorkflowProcess.find_by(workflow: self.requisition_type)
  self.workflow_state_id = InitialState.find_by(workflow_process_id: process&.id)&.workflow_state_id
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
  def quantity
    if self.requisition_type == "Purchase Request"
      return self.requisition_items.first.quantity
    end
  end

  def amount
    if self.requisition_type == "Petty Cash"
      return self.requisition_items.first.value
    end
  end
  def item_description
    if self.requisition_type == "Purchase Request"
      return self.requisition_items.first.item_description
    end
  end
  def used_amount
    if self.requisition_type == "Petty Cash"
      return self.petty_cash_comments.first&.used_amount || 'Missing'
    end
    # nil # Or 0, or some default value if not a "Petty Cash" requisition
  end
  private
end
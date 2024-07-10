# frozen_string_literal: true
class WorkflowStateTransition < ApplicationRecord
  has_one :workflow_state, :foreign_key => :next_state
  has_one :workflow_state, :foreign_key => :workflow_state_id
  has_one :workflow_process, through: :workflow_state
  def self.possible_actions(state, user, is_owner= false)
    actions = []
    (WorkflowStateTransition.where(workflow_state_id: state) || []).each do |transition|
      if is_owner
        actions.append(transition.action) if transition.by_owner
      elsif WorkflowStateTransitioner.where(stakeholder: user.employee.current_designations.collect(&:designation_id),
                                            workflow_state_transition: transition.id)
        actions.append(transition.action)
      end
    end
    actions
  end
end

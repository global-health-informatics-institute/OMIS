class RemoveBySuperviserFromWorkflowStateTransition < ActiveRecord::Migration[7.0]
  def change
    remove_column :workflow_state_transitions, :by_superviser
  end
end

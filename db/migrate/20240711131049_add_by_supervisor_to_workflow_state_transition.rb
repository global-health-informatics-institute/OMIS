class AddBySupervisorToWorkflowStateTransition < ActiveRecord::Migration[7.0]
  def change
    add_column :workflow_state_transitions, :by_supervisor, :boolean
  end
end

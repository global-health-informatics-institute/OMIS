class AddTransitionersToWorkflowStateTransition < ActiveRecord::Migration[7.0]
  def change
    add_column :workflow_state_transitions, :transitioners, :string
  end
end

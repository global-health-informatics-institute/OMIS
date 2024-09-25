class AddActionToWorkflowProcessTransition < ActiveRecord::Migration[7.0]
  def change
    add_column :workflow_state_transitions,:action, :string, null: false, after: :next_state
    add_column :workflow_state_transitions,:by_owner, :boolean, default: false, after: :action
  end
end

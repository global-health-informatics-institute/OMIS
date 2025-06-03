class AddWorkflowStateIdToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :workflow_state_id, :integer
  end
end

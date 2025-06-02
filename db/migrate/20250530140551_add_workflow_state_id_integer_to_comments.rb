class AddWorkflowStateIdIntegerToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :workflow_state_id, :integer # You can set a default if needed
  end
end

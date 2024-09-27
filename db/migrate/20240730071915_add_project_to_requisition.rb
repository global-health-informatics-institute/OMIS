class AddProjectToRequisition < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :project_id, :integer
  end
end

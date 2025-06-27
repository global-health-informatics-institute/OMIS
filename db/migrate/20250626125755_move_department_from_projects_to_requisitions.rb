class MoveDepartmentFromProjectsToRequisitions < ActiveRecord::Migration[7.0]
  def change
    # Remove from projects
    remove_foreign_key :projects, column: :department_id if foreign_key_exists?(:projects, column: :department_id)
    remove_column :projects, :department_id, :integer if column_exists?(:projects, :department_id)

    # Add to requisitions table
    add_column :requisitions, :department_id, :integer
    add_foreign_key :requisitions, :departments, column: :department_id, primary_key: :department_id
  end
end

class AddForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :employees, :people, column: :person_id, primary_key: :person_id
    add_foreign_key :departments, :branches, column: :branch_id, primary_key: :branch_id
  end
end

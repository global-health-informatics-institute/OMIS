class CreateFinalStates < ActiveRecord::Migration[7.0]
  def change
    create_table :final_states do |t|
      t.integer :workflow_process_id
      t.integer :workflow_state_id

      t.timestamps
    end
  end
end

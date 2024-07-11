class CreateInitialStates < ActiveRecord::Migration[7.0]
  def change
    create_table :initial_states, :primary_key => 'initial_state_id' do |t|
      t.integer :workflow_process_id
      t.integer :workflow_state_id
      t.timestamps
    end
  end
end

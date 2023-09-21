class CreateSupervisions < ActiveRecord::Migration[7.0]
  def change
    create_table :supervisions, :primary_key => 'supervision_id' do |t|
      t.integer :supervisor , null: false
      t.integer :supervisee , null: false
      t.date :started_on
      t.date :ended_on
      t.boolean :is_terminated, null: false, default: false
      t.timestamps
    end
  end
end

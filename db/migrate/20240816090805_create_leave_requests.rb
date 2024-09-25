class CreateLeaveRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :leave_requests, :primary_key => 'leave_request_id' do |t|
      t.string :leave_type, null: false
      t.integer :employee_id, null: false
      t.datetime :start_on, null: false
      t.datetime :end_on, null: false
      t.integer :stand_in, null: false
      t.boolean :reviewed_by
      t.boolean :reviewed_on
      t.boolean :approved_by
      t.boolean :approved_on
      t.integer :status, null: false
      t.timestamps
    end
  end
end

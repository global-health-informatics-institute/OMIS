class CreateLeaveSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :leave_summaries, :primary_key => 'leave_summary_id' do |t|
      t.string :leave_type, null: false
      t.integer :employee_id, null: false
      t.float :leave_days_total, null: false
      t.float :leave_days_balance, null: false
      t.integer :financial_year, null: false
      t.timestamps
    end
  end
end

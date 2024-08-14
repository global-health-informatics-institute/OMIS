class CreateReportStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :report_statistics, :primary_key => 'statistic_id'  do |t|
      t.date :period_start, null:false
      t.date :period_end, null: false
      t.string :period_label, null: false
      t.string :statistic_description, null: false
      t.decimal :statistic_value, null: false
      t.timestamps
    end
  end
end

class CreateTokenLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :token_logs, :primary_key => 'token_id' do |t|
      t.string :token, null:false
      t.timestamps
    end
  end
end

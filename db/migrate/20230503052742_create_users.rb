class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, :primary_key => 'user_id' do |t|
      t.integer :employee_id, null: false
      t.string :username, null: false
      t.string :password_digest
      t.string :password_confirmation
      t.timestamp :activated_at 
      t.timestamp :deactivated_at
      t.boolean :reset_needed, null: false, default: false
      t.boolean :activated, default: false
      t.timestamp :last_login
      t.timestamps
    end
  end
end

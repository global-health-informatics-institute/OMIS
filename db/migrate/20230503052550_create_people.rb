class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people, :primary_key => 'person_id' do |t|
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name, null: false
      t.date :birth_date, null: false
      t.string :gender, null: false
      t.string :marital_status, null: false
      t.string :primary_phone
      t.string :alt_phone
      t.string :email_address
      t.string :official_email
      t.string :postal_address
      t.string :residential_address
      t.string :landmark
      t.boolean :voided, default: false
      t.timestamps
    end
  end
end

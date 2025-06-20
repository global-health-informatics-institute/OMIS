class CreateStakeholders < ActiveRecord::Migration[7.0]
  def change
    create_table :stakeholders, id: false do |t|
      t.primary_key :stakeholder_id

      t.string :stakeholder_name, null: false
      t.string :contact_email

      t.boolean :is_partner, default: false
      t.boolean :is_donor, default: false

      t.string :donation_frequency
      t.string :partnership_tier

      t.boolean :voided, default: false

      t.timestamps
    end
  end
end

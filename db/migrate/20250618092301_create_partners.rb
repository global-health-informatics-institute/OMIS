class CreatePartners < ActiveRecord::Migration[7.0]
  def change
    create_table :partners, id: false do |t|
      t.integer :partner_id, primary_key: true
      t.string :partner_name
      t.text :description
      t.boolean :voided

      t.timestamps
    end
  end
end

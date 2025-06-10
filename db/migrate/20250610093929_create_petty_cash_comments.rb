class CreatePettyCashComments < ActiveRecord::Migration[7.0]
  def change
    create_table :petty_cash_comments do |t|
      t.text :comment
      t.decimal :used_amount
      t.references :requisition, null: false, foreign_key: true

      t.timestamps
    end
  end
end

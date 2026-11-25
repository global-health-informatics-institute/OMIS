# frozen_string_literal: true

class CreateSuppliersAndRequisitionItemQuotations < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    create_table :suppliers do |t|
      t.references :requisition,
                   type: :integer,
                   null: false,
                   foreign_key: { to_table: :requisitions, primary_key: :requisition_id }
      t.string :name, null: false
      t.string :mobile_number, null: false
      t.string :email, null: false
      t.boolean :voided, null: false, default: false
      t.timestamps
    end

    add_index :suppliers, %i[requisition_id email], unique: true

    create_table :requisition_item_quotations do |t|
      t.references :requisition_item,
                   type: :integer,
                   null: false,
                   foreign_key: { to_table: :requisition_items, primary_key: :requisition_item_id }
      t.references :supplier, null: false, foreign_key: true
      t.decimal :unit_price, precision: 12, scale: 2, null: false
      t.timestamps
    end

    add_index :requisition_item_quotations,
              %i[requisition_item_id supplier_id],
              unique: true,
              name: 'idx_item_quotations_on_item_and_supplier'
  end
end

# frozen_string_literal: true

class CreateChargesAndRequisitionItemCharges < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    create_table :charges do |t|
      t.string     :name, null: false
      t.string     :value_type, null: false, default: 'rate' # immutable
      t.references :global_property,
                   type: :integer,
                   null: false,
                   foreign_key: { to_table: :global_properties, primary_key: :property_id }
      t.boolean    :applies_to_item,     null: false, default: true
      t.boolean    :applies_to_supplier, null: false, default: false
      t.boolean    :voided, null: false, default: false
      t.string     :void_reason
      t.datetime   :date_voided
      t.timestamps
    end

    add_index :charges, :name, unique: true

    create_table :requisition_item_charges do |t|
      t.references :requisition_item,
                   type: :integer,
                   null: false,
                   foreign_key: { to_table: :requisition_items, primary_key: :requisition_item_id }
      t.references :charge, null: false, foreign_key: true
      t.decimal    :charge_value, precision: 12, scale: 4, null: false # snapshot
      t.timestamps
    end

    add_index :requisition_item_charges,
              %i[requisition_item_id charge_id],
              unique: true,
              name: 'idx_req_item_charges_on_item_and_charge'
  end
end

# frozen_string_literal: true

class AddWorkflowApprovalsToPurchaseRequestDetails < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    change_table :purchase_request_details, bulk: true do |t|
      t.integer :lpo_prepared_by
      t.datetime :lpo_prepared_on
      t.integer :lpo_finance_approved_by
      t.datetime :lpo_finance_approved_on
      t.integer :lpo_ed_approved_by
      t.datetime :lpo_ed_approved_on

      t.integer :payment_request_prepared_by
      t.datetime :payment_request_prepared_on
      t.integer :payment_request_finance_approved_by
      t.datetime :payment_request_finance_approved_on
      t.integer :payment_request_ed_approved_by
      t.datetime :payment_request_ed_approved_on

      t.integer :payment_voucher_prepared_by
      t.datetime :payment_voucher_prepared_on
      t.integer :payment_voucher_finance_approved_by
      t.datetime :payment_voucher_finance_approved_on
      t.integer :payment_voucher_ed_approved_by
      t.datetime :payment_voucher_ed_approved_on
    end
  end
end

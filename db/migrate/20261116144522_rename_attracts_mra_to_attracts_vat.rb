# frozen_string_literal: true

class RenameAttractsMraToAttractsVat < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    rename_column :purchase_request_details, :attracts_mra, :attracts_vat
  end
end

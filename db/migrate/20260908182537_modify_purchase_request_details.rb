class ModifyPurchaseRequestDetails < ActiveRecord::Migration[7.0]
  def change
    # Remove redundant column: equivalent to requisition_donors.donor_id
    remove_column :purchase_request_details, :donor_id, :integer

    
    add_column :purchase_request_details, :reviewed_on, :datetime
  end
end

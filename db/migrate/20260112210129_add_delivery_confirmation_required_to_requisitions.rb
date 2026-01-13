class AddDeliveryConfirmationRequiredToRequisitions < ActiveRecord::Migration[7.0]
  def change
    add_column :requisitions, :delivery_confirmation_required, :boolean, default: false
  end
end

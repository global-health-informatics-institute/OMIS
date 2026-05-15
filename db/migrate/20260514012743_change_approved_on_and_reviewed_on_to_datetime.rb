# frozen_string_literal: true

# migration to correct the data types for approved and reviewed on
class ChangeApprovedOnAndReviewedOnToDatetime < ActiveRecord::Migration[7.0]
  def change
    change_column :leave_requests, :approved_on, :datetime, null: true,
                                                            using: 'CASE WHEN approved_on THEN updated_at ELSE NULL END'
    change_column :leave_requests, :reviewed_on, :datetime, null: true,
                                                            using: 'CASE WHEN reviewed_on THEN updated_at ELSE NULL END'
  end
end

# app/helpers/requisitions/purchase_requests_helper.rb
module Requisitions::PurchaseRequestsHelper
  def purchase_request_state_badge_class(state)
    case state.to_s.downcase
    when 'requested', 'pending approval', 'pending supervisor approval'
      'bg-secondary text-white'
    when 'approved'
      'bg-success text-white'
    when 'rejected', 'denied', 'voided'
      'bg-danger text-white'
    when 'recalled', 'draft', 'pending submission'
      'bg-warning text-dark'
    when 'under review', 'pending review'
      'bg-info text-white'
    else
      'bg-secondary text-white'
    end
  end
end
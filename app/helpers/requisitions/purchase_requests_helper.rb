# frozen_string_literal: true

# app/helpers/requisitions/purchase_requests_helper.rb
module Requisitions
  module PurchaseRequestsHelper # rubocop:disable Style/Documentation
    def purchase_request_state_badge_class(state) # rubocop:disable Metrics/MethodLength
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

    def available_actions_badge_class(action)
      case action.to_s.downcase
      # actions when state "Pending Supervisor Review"
      when 'approve purchase request'
        'bg-success text-white'
      when 'recall purchase request'
        'bg-warning text-dark'
      when 'rescind purchase request', 'decline purchase request'
        'bg-danger text-white'
      else
        'bg-secondary text-white'
      end
    end
  end
end

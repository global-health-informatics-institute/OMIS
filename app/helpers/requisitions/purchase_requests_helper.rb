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
      when 'purchase request rescinded', 'purchase request declined', 'voided'
        'bg-danger text-white'
      when 'purchase request recalled', 'draft', 'pending submission'
        'bg-warning text-dark'
      when 'under review', 'pending review'
        'bg-info text-white'
      else
        'bg-secondary text-white'
      end
    end

    def available_actions_badge_class(action) # rubocop:disable Metrics/MethodLength
      case action.to_s.downcase
      # actions when state "Pending Supervisor Review"
      when 'approve purchase request'
        'bg-success text-white'
      when 'recall purchase request'
        'bg-warning text-dark'
      when 'rescind purchase request', 'decline purchase request'
        'bg-danger text-white'
      when 'resubmit purchase request', 'request ipc', 'request lpo'
        'bg-primary text-white'
      else
        'bg-secondary text-white'
      end
    end

    def field_edit_options(purchase_request, user)
      editable = purchase_request.editable_by?(user)

      {
        readonly: !editable,
        disabled: !editable
      }
    end

    def action_route_verb(action)
      # 1. Removes the words "Purchase Request" (case insensitive)
      # 2. Strips leading/trailing whitespace
      # 3. Parameterizes with underscores
      #
      # "Approve Purchase Request" -> "approve"
      # "Recall Purchase Request"  -> "recall"
      # "Request IPC"              -> "request_ipc"
      # "Request LPO"              -> "request_lpo"
      action.gsub(/Purchase Request/i, '').strip.parameterize(separator: '_')
    end
  end
end

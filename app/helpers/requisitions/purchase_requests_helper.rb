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
      when 'rescind purchase request', 'decline purchase request', 'mark sourcing as failed'
        'bg-danger text-white'
      when 'resubmit purchase request', 'route to ipc', 'route to lpo', 'save qoutation'
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

    def show_section?(purchase_request, section) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
      case section.to_sym
      when :approval
        # Visible once an approver or approval timestamp is attached
        purchase_request.approved_by.present? || purchase_request.approved_on.present?

      when :review
        # Visible once reviewed by a supervisor
        purchase_request.reviewed_by.present? || purchase_request.reviewed_on.present?
      when :sourcing
        # Reserved for finance metadata (quotes/vendors)
        (purchase_request.current_state.in? ['Pending IPC', 'Pending IPO', 'Pending Payment Request']) &&
          (current_user&.employee_id != purchase_request&.initiated_by)
      else
        true
      end
    end

    # Block helper for clean ERB syntax
    def render_section_if(purchase_request, section, &block)
      capture(&block) if show_section?(purchase_request, section)
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

    def cap_limit(route_type) # rubocop:disable Metrics/MethodLength
      threshold = PurchaseRequest.ipc_threshold

      if route_type.to_s.downcase == 'pending ipc'
        {
          min: threshold,
          placeholder: "value not less than #{threshold}"
        }
      else
        {
          max: threshold - 1,
          placeholder: "value not more or equal to #{threshold}"
        }
      end
    end
  end
end

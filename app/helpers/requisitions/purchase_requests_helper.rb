# frozen_string_literal: true

# app/helpers/requisitions/purchase_requests_helper.rb
module Requisitions
  module PurchaseRequestsHelper # rubocop:disable Style/Documentation,Metrics/ModuleLength
    REQUEST_DETAIL_STATES = [
      'Pending Supervisor Review',
      'Purchase Request Declined',
      'Pending Sourcing Quotation',
      'Pending IPC - Vendor Analysis',
      'Pending Vendor Analysis',
      'Purchase Request Recalled',
      'Pending Item Acceptance',
      'Purchase Request Complete'
    ].freeze

    REQUEST_APPROVE_STATE = [
      'Pending Sourcing Quotation',
      'Purchase Request Complete'
    ].freeze

    ITEM_DETAIL_STATES = (REQUEST_DETAIL_STATES + [
      'Pending LPO Check',
      'Pending Payment Request',
      'Payment Request',
      'Pending LPO Request Submission',
      'Pending LPO Review - Finance Team',
      'Pending LPO Review - ED',
      'Pending Delivery Confirmation',
      'Pending Item Acceptance',
      'Item Delivery Failed',
      'Pending Payment Request Review - Finance Team',
      'Pending Payment Request Review - ED',
      'Pending Payment Voucher',
      'Pending Payment Voucher Review - Finance Team',
      'Pending Payment Voucher Review - ED'
    ]).freeze

    SOURCING_QOUTATION_STATES = [
      'Pending IPC - Vendor Analysis',
      'Pending Vendor Analysis',
      'Pending LPO Check',
      'Pending LPO Request Submission',
      'Pending LPO Review - Finance Team',
      'Pending LPO Review - ED',
      'Pending Delivery Confirmation',
      'Item Delivery Failed',
      'Pending Payment Request',
      'Pending Payment Request Review - Finance Team',
      'Pending Payment Request Review - ED',
      'Pending Payment Voucher',
      'Pending Payment Voucher Review - Finance Team',
      'Pending Payment Voucher Review - ED',
      'Purchase Request Complete'
    ].freeze

    TAX_RATE_STATES = [
      'Pending IPC - Vendor Analysis',
      'Pending Vendor Analysis',
      'Pending LPO Check',
      'Pending LPO Request Submission',
      'Pending LPO Review - Finance Team',
      'Pending LPO Review - ED',
      'Pending Delivery Confirmation',
      'Pending Item Acceptance',
      'Pending Payment Request',
      'Pending Payment Request Review - Finance Team',
      'Pending Payment Request Review - ED',
      'Pending Payment Voucher',
      'Pending Payment Voucher Review - Finance Team',
      'Pending Payment Voucher Review - ED',
      'Purchase Request Complete'
    ].freeze

    def purchase_request_state_badge_class(state) # rubocop:disable Metrics/MethodLength
      case state.to_s.downcase
      when 'requested', 'pending approval', 'pending supervisor approval'
        'bg-secondary text-white'
      when 'approved', 'purchase request complete'
        'bg-success text-white'
      when 'purchase request rescinded', 'purchase request declined', 'voided', 'item delivery failed'
        'bg-danger text-white'
      when 'purchase request recalled', 'draft', 'pending submission'
        'bg-warning text-dark'
      when 'under review', 'pending review', 'pending sourcing quotation', 'pending ipc - vendor analysis',
        'pending vendor analysis', 'pending lpo check', 'pending lpo request submission',
        'pending lpo review - finance team', 'pending lpo review - ed', 'pending delivery confirmation',
        'pending item acceptance', 'pending payment request', 'pending payment request review - finance team',
        'pending payment request review - ed', 'pending payment voucher', 'pending payment voucher review - finance team',
        'pending payment voucher review - ed'
        'bg-secondary text-white'
      else
        'bg-info text-black'
      end
    end

    def available_actions_badge_class(action) # rubocop:disable Metrics/MethodLength
      case action.to_s.downcase
      # actions when state "Pending Supervisor Review"
      when 'approve purchase request', 'confirm delivery', 'approve lpo request', 'accept item',
        'approve payment request', 'approve payment voucher'
        'bg-success text-white'
      when 'recall purchase request', 'choose other vendor'
        'bg-warning text-dark'
      when 'rescind purchase request', 'decline purchase request', 'mark sourcing as failed', 'mark delivery as failed',
        'decline item', 'terminate payment request', 'terminate payment voucher'
        'bg-danger text-white'
      when 'resubmit purchase request',
        'route to ipc - vendor analysis', 'route to lpo', 'save qoutation',
        'forward to vendor analysis', 'prepare lpo request', 'prepare payment request', 'prepare payment voucher'
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

    def purchase_request_departments
      Department.order(:department_name).pluck(:department_name, :department_id)
    end

    def show_section?(purchase_request, section) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity
      state = purchase_request.current_state

      case section.to_sym
      when :request_details
        purchase_request.requester?(current_user) || state.in?(REQUEST_DETAIL_STATES)
      when :item_details
        state.in?(ITEM_DETAIL_STATES)
      when :approval
        purchase_request.requester?(current_user) || (
          state.in?(REQUEST_APPROVE_STATE) &&
          (purchase_request.approved_by.present? || purchase_request.approved_on.present?)
        )
      when :review
        purchase_request.reviewed_by.present? || purchase_request.reviewed_on.present?
      when :sourcing_qoutations
        state.in?(SOURCING_QOUTATION_STATES) && current_user&.employee_id != purchase_request.initiated_by
      when :tax_rates
        state.in?(TAX_RATE_STATES) && current_user&.employee_id != purchase_request.initiated_by
      when :action_items
        state != 'Pending LPO Check'
      when :lpo_check
        state == 'Pending LPO Check' && purchase_request.actor?(current_user)
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
      action.gsub(/Purchase Request/i, '')
            .strip
            .gsub(/[^a-zA-Z0-9]+/, '_')
            .downcase
            .squeeze('_')
            .delete_prefix('_')
            .delete_suffix('_')
    end

    def form_validation_bypass_actions # rubocop:disable Metrics/MethodLength
      # Actions that change or reverse workflow state without saving form fields.
      [
        'decline purchase request',
        'mark sourcing as failed',
        'mark delivery as failed',
        'choose other vendor',
        'confirm delivery',
        'accept item',
        'decline item',
        'terminate payment request',
        'terminate payment voucher',
        'recall purchase request',
        'rescind purchase request'
      ]
    end

    def quotation_cap_rule(purchase_request)
      case purchase_request.current_state.to_s.downcase
      when 'pending ipc - vendor analysis'
        'at_least'
      when 'pending vendor analysis'
        'less_than'
      end
    end

    def cap_limit(route_type) # rubocop:disable Metrics/MethodLength
      threshold = PurchaseRequest.ipc_threshold

      if route_type.to_s.downcase == 'pending ipc - vendor analysis'
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

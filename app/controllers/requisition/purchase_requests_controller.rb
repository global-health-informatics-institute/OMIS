# frozen_string_literal: true

module Requisitions
  class PurchaseRequestsController < ApplicationController # rubocop:disable Style/Documentation
    def index
      @purchase_requests = Requisition.where(
        request_type: 'purchase request'
      ).order(created_at: :desc).limit(10)
    end

    def new
      @purchase_request = Requisition.new
      @purchase_request.build_purchase_request_detail
      @purchase_request.requisition_items.build
    end

    def create; end

    def show
      @test_requisition = Requisition.first
    end

    def update; end

    def destroy; end

    def approve; end

    def decline; end
  end
end

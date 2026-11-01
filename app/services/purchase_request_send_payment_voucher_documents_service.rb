# frozen_string_literal: true

require 'tmpdir'

class PurchaseRequestSendPaymentVoucherDocumentsService # rubocop:disable Style/Documentation
  SENIOR_FINANCE_DESIGNATIONS = [
    'Director of Finance and Administration',
    'Finance & Administration Lead',
    'Finance Lead'
  ].freeze

  class << self
    def call(purchase_request)
      new(purchase_request).call
    end
  end

  def initialize(purchase_request)
    @purchase_request = purchase_request
  end

  def call # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    raise ArgumentError, 'The Executive Director approver has no email address' if ed_email.blank?

    Dir.mktmpdir("payment-voucher-#{purchase_request.requisition_id}-") do |directory|
      signed_payment_voucher_path = File.join(directory, 'signed_payment_voucher.pdf')
      unsigned_payment_voucher_path = File.join(directory, 'unsigned_payment_voucher.pdf')
      token = SecureRandom.alphanumeric
      TokenLog.create!(token: token)

      PurchaseRequestGeneratePaymentVoucherFileService.generate_signed_payment_voucher(
        purchase_request:,
        token:,
        output_path: signed_payment_voucher_path
      )
      PurchaseRequestGeneratePaymentVoucherFileService.generate_unsigned_payment_voucher(
        purchase_request:,
        output_path: unsigned_payment_voucher_path
      )

      PurchaseRequestMailer.payment_voucher_documents(
        purchase_request,
        ed_email,
        senior_finance_emails,
        signed_payment_voucher_path,
        unsigned_payment_voucher_path
      ).deliver_now
    end
  end

  private

  attr_reader :purchase_request

  def ed_email
    @ed_email ||= email_for(purchase_request.purchase_request_detail.payment_voucher_ed_approver)
  end

  def senior_finance_emails
    Employee.joins(employee_designations: :designation)
            .includes(:person)
            .where(still_employed: true, employee_designations: { end_date: nil },
                   designations: { designated_role: SENIOR_FINANCE_DESIGNATIONS })
            .filter_map { |employee| email_for(employee) }
            .uniq
            .excluding(ed_email)
  end

  def email_for(employee)
    person = employee&.person
    person&.official_email.presence || person&.email_address
  end
end

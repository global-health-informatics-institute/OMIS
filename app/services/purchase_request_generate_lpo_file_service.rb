# frozen_string_literal: true

# Generates an LPO file for a purchase request
class PurchaseRequestGenerateLpoFile # rubocop:disable Metrics/ClassLength
  extend PdfHelper # gives us _write_line, _add_footer, _add_stamp, ensure_space as class methods

  LETTERHEAD = 'app/assets/images/GHII-Letterhead.png'
  NBSP = Prawn::Text::NBSP
  SIGNOFF_GAP = 300
  SIGNATURE_GAP = 30 # space left above the signature line for signing
  TOKEN_LABEL = 'OMIS generated token' # only shown on the signed LPO
  STAMP_Y = 160
  STAMP_WIDTH = 180

  ONES = %w[zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen
            fifteen sixteen seventeen eighteen nineteen].freeze
  TENS = %w[_ _ twenty thirty forty fifty sixty seventy eighty ninety].freeze
  SCALES = [[1_000_000_000, 'billion'], [1_000_000, 'million'], [1_000, 'thousand']].freeze

  class << self
    # Placeholder data only, so the layout can be previewed. Returns the path of the generated PDF.
    def generate_signed_lpo(output_path = 'tmp/signed_lpo_preview.pdf')
      _build_lpo(output_path:, signed: true)
    end

    # Same document without the token and stamp, with signature lines and blank date lines to fill in by hand.
    def generate_unsigned_lpo(output_path = 'tmp/unsigned_lpo_preview.pdf')
      _build_lpo(output_path:, signed: false)
    end

    private

    def _build_lpo(output_path:, signed:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      data = _placeholder_data
      info_rows = signed ? data[:info] : data[:info].reject { |label, _value| label == TOKEN_LABEL }

      Prawn::Document.generate(output_path, page_size: 'A4', page_layout: :portrait,
                                            left_margin: 40, right_margin: 40) do |pdf|
        pdf.image LETTERHEAD, width: pdf.bounds.width
        pdf.move_down 20
        pdf.text 'Local Purchase Order', size: 18, style: :bold, align: :center
        pdf.move_down 20

        _add_info_table(pdf:, rows: info_rows)
        _add_agreement(pdf:, validity_days: data[:validity_days])
        _add_items_table(pdf:, item: data[:item])

        if signed
          _add_signoff_section(pdf:, signoffs: data[:signoffs])
        else
          _add_unsigned_signoff_section(pdf:, signoffs: data[:signoffs])
        end

        _add_footer(pdf:)
        _add_stamp(pdf:, y: STAMP_Y, width: STAMP_WIDTH) if signed
      end

      output_path
    end

    # Label, colon and value are separate columns so every colon lines up.
    # The label column is kept wide on purpose: Prawn caches word widths without the font size, so after the
    # 18pt title "Purchase" is measured too wide in this 10pt table and "Purchase Request No" would wrap.
    def _add_info_table(pdf:, rows:)
      table_rows = rows.map { |label, value| [label, ':', value] }

      pdf.table(table_rows, column_widths: [155, 12, pdf.bounds.width - 167],
                            cell_style: { borders: [], padding: [3, 5], size: 10 }) do
        columns(0..1).font_style = :bold
        column(0).padding = [3, 0, 3, 5]
        column(1).padding = [3, 0]
      end
      pdf.move_down 15
    end

    # Thin rule to set the agreement terms apart from the order details, text slightly smaller than the body.
    def _add_agreement(pdf:, validity_days:) # rubocop:disable Metrics/MethodLength
      pdf.mask(:line_width, :stroke_color) do
        pdf.line_width = 0.5
        pdf.stroke_color '999999'
        pdf.stroke_horizontal_rule
      end
      pdf.move_down 8
      pdf.text 'This document constitutes an agreement between the vendor and the Global Health ' \
               'Informatics Institute (the buyer) for the provision of the services/items specified below:',
               align: :justify, size: 9
      pdf.move_down 5
      pdf.text "<b>Note:</b> This LPO is valid for a period of #{validity_days} days after approval date",
               inline_format: true, size: 9
      pdf.move_down 20
    end

    def _add_items_table(pdf:, item:)
      ensure_space(pdf:, required_height: 120)

      pdf.table(_items_table_data(item), column_widths: [38, 125, 72, 55, 65, 65, 95], header: true,
                                         cell_style: { size: 9 }) do
        row(0).font_style = :bold
        row(0).background_color = 'EEEEEE'
        columns(2..6).align = :right
      end

      pdf.move_down 12
      pdf.text "<b>Amount in words:</b> #{_amount_in_words(item[:total])}", inline_format: true, size: 10
      pdf.move_down 30
    end

    def _items_table_data(item) # rubocop:disable Metrics/MethodLength
      [
        ['Item No', 'Description', 'Unit Price', 'Quantity', 'MRA Fee (MWK)', 'Levy Fee (MWK)', 'Total (MWK)'],
        [
          item[:number].to_s,
          item[:description].to_s,
          _money(item[:unit_price]),
          item[:quantity].to_s,
          _money(item[:mra_fee]),
          _money(item[:levy_fee]),
          _money(item[:total])
        ]
      ]
    end

    def _add_signoff_section(pdf:, signoffs:)
      signoffs.each do |label, name, date_label, date|
        _write_line(
          pdf:,
          previous_text: "#{label}: #{NBSP}#{name || '--'}",
          next_text: "#{date_label}: #{NBSP}#{_fmt_date(date)}",
          move_down: 20, target_width: SIGNOFF_GAP
        )
      end
    end

    # Names stay; each person gets a blank date line and a signature line to fill in by hand.
    #   Prepared By:  Name              Date Prepared: ____________
    #   Signature: ______________
    def _add_unsigned_signoff_section(pdf:, signoffs:) # rubocop:disable Metrics/MethodLength
      signoffs.each do |label, name, date_label, _date|
        ensure_space(pdf:, required_height: 30) # a block is ~60pt tall but ensure_space already keeps a footer zone free

        name_baseline = pdf.cursor - pdf.font.ascender
        pdf.draw_text "#{label}: #{NBSP}#{name || '--'}", at: [0, name_baseline]
        _blank_field(pdf:, label: "#{date_label}:", x: SIGNOFF_GAP, baseline: name_baseline,
                     line_end: pdf.bounds.width)

        signature_baseline = name_baseline - SIGNATURE_GAP
        _blank_field(pdf:, label: 'Signature:', x: 0, baseline: signature_baseline, line_end: SIGNOFF_GAP - 40)

        pdf.move_cursor_to signature_baseline - 22
      end
    end

    # A label followed by a ruled line to write on.
    def _blank_field(pdf:, label:, x:, baseline:, line_end:)
      pdf.draw_text label, at: [x, baseline]
      pdf.mask(:line_width, :stroke_color) do
        pdf.line_width = 0.75
        pdf.stroke_color '000000'
        pdf.stroke_horizontal_line(x + pdf.width_of(label) + 6, line_end, at: baseline - 2)
      end
    end

    def _money(amount)
      ActiveSupport::NumberHelper.number_to_currency(amount || 0, unit: '', precision: 2)
    end

    def _fmt_date(date)
      date&.strftime('%d %B %Y') || '--'
    end

    # 312000.0 -> "Three hundred and twelve thousand Malawi Kwacha only"
    def _amount_in_words(amount)
      kwacha, tambala = (amount.to_d * 100).round.to_i.divmod(100)
      text = "#{_number_to_words(kwacha)} Malawi Kwacha"
      text += " and #{_number_to_words(tambala)} Tambala" if tambala.positive?
      "#{text} only".sub(/\A./, &:upcase)
    end

    def _number_to_words(number) # rubocop:disable Metrics/MethodLength
      return ONES[0] if number.zero?

      words = []
      SCALES.each do |value, name|
        next if number < value

        words << "#{_words_below_thousand(number / value)} #{name}"
        number %= value
      end
      if number.positive?
        chunk = _words_below_thousand(number)
        words << (number < 100 && words.any? ? "and #{chunk}" : chunk)
      end
      words.join(' ')
    end

    def _words_below_thousand(number) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      parts = []
      if number >= 100
        parts << "#{ONES[number / 100]} hundred"
        number %= 100
        parts << 'and' if number.positive?
      end
      if number >= 20
        parts << ((number % 10).zero? ? TENS[number / 10] : "#{TENS[number / 10]}-#{ONES[number % 10]}")
      elsif number.positive?
        parts << ONES[number]
      end
      parts.join(' ')
    end

    def _placeholder_data # rubocop:disable Metrics/MethodLength
      today = Date.current
      lpo_number = 'LPO-2026-0001'
      {
        info: [
          ['LPO No', lpo_number],
          ['Purchase Request No', '142'],
          ['OMIS generated token', '3ZVfxjuq9uOQgVMD'],
          ['Vendor Name', 'Sample Vendor Ltd'],
          ['Vendors Mobile', '+265 999 000 000'],
          ['Vendor Email', 'vendor@example.com'],
          ['Delivery Date', _fmt_date(today + 9)],
          ['Terms of Payment', '30 days after delivery'],
          ['Delivery Point', 'Global Health Informatics Institute, Main Office'],
          ['Project', 'GHII'],
          ['Order Date', _fmt_date(today)]
        ],
        validity_days: 9,
        item: {
          number: 1, description: 'Sample item description (placeholder text)',
          unit_price: 150_000, quantity: 2, mra_fee: 25_500, levy_fee: 7_500, total: 366_000
        },
        signoffs: [
          ['Prepared By', 'Preparer Full Name', 'Date Prepared', today],
          ['Reviewed By', 'Reviewer Full Name', 'Date Reviewed', today],
          ['Approved By', 'Approver Full Name', 'Date Approved', today]
        ]
      }
    end
  end
end
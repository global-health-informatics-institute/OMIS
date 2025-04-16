# frozen_string_literal: true

# app/helpers/notifications_helper.rb
# app/helpers/notifications_helper.rb
module NotificationsHelper
  def birthday_snackbar(messages, duration: 3000, color: 'success') # rubocop:disable Metrics/MethodLength
    return if messages.blank?

    tag.div(
      '', # We'll populate via Stimulus
      class: 'snackbar',
      data: {
        controller: 'snackbar',
        snackbar_messages_value: messages.to_json,
        snackbar_duration_value: duration,
        snackbar_color_value: color
      }
    )
  end
end

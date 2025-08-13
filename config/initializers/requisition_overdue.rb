Rails.application.configure do
  # Default: 14 days, but can be overridden by ENV var
  config.x.requisition.overdue_days_threshold = ENV.fetch('REQUISITION_OVERDUE_DAYS', 14).to_i
end
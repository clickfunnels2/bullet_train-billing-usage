module Billing::UsageSupport
  extend ActiveSupport::Concern

  def track_billing_usage(action, model: nil, count: 1)
    model ||= self.class

    billing_usage_trackers.current.each do |tracker|
      tracker.track(action, model, count)
    end
  end
end

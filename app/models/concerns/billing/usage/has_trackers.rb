module Billing::Usage::HasTrackers
  extend ActiveSupport::Concern

  included do
    has_many :billing_usage_trackers, as: :trackable, class_name: "Billing::Usage::Tracker", dependent: :destroy do
      def current
        Billing::Usage::Tracker.cycles(proxy_association.owner).map do |cycle|
          duration, interval = cycle

          workspace_id = if proxy_association.owner.is_a?(Workspace)
            proxy_association.owner.id
          else
            proxy_association.owner.workspace.id
          end

          # This will grab the most recent tracker for this usage cycle.
          # If it doesn't exist, it will be created. This can happen if developers introduce new usage cycles to track by.
          order(created_at: :desc).includes(:counts).find_or_create_by(
            workspace_id: workspace_id,
            duration: duration,
            interval: interval
          )
        end
      end
    end
  end
end

module Billing::Usage::HasTrackers
  extend ActiveSupport::Concern

  included do
    has_many :billing_usage_trackers, as: :trackable, class_name: "Billing::Usage::Tracker", dependent: :destroy do
      def current
        Billing::Usage::Tracker.cycles(proxy_association.owner).map do |cycle|
          duration, interval = cycle

          # Determine if workspace_id is a valid column
          has_workspace_column = Billing::Usage::Tracker.column_names.include?('workspace_id')
          has_team_column = Billing::Usage::Tracker.column_names.include?('team_id')
          
          # Get the attributes common to all environments
          tracker_attributes = {
            duration: duration,
            interval: interval
          }
          
          # Only add workspace_id if it exists in the schema
          if has_workspace_column
            workspace_id = if defined?(::Workspace) && proxy_association.owner.is_a?(::Workspace)
              proxy_association.owner.id
            elsif proxy_association.owner.respond_to?(:workspace) && proxy_association.owner.workspace.present?
              proxy_association.owner.workspace.id
            elsif proxy_association.owner.respond_to?(:workspace_id) && proxy_association.owner.workspace_id.present?
              proxy_association.owner.workspace_id
            else
              proxy_association.owner.id # Fallback to owner's ID
            end
            
            tracker_attributes[:workspace_id] = workspace_id
          end

          if has_team_column
            team_id = proxy_association.owner.id
            tracker_attributes[:team_id] = team_id
          end

          # Find or create the tracker with the appropriate attributes
          order(created_at: :desc).includes(:counts).find_or_create_by(tracker_attributes)
        end
      end
    end
  end
end

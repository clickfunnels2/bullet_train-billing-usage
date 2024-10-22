class AddTrackableToBillingUsageTracker < ActiveRecord::Migration[7.1]
  def change
    add_column :billing_usage_trackers, :trackable_id, :bigint
    add_column :billing_usage_trackers, :trackable_type, :string, default: "Team"
    add_index :billing_usage_trackers, [:trackable_id, :trackable_type]
  end
end

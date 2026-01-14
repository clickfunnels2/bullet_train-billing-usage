# Setup Guide

1. Clone the repository
2. `bundle install` dependencies
3. `bundle exec rake db:create`
4. `bin/rails db:migrate RAILS_ENV=test`

rbenv local `3.1.6` (what Admin currently uses)

Added getting the `bullet-train-billing` repo via GemFury in `Gemfile`
```
source "<Value from Admin Gemfile>@gem.fury.io/bullettrain" do
  gem 'bullet_train-billing'
end
```

Updated `charlock_holmes` to compatible version in `Gemfile.lock` (was unsure if I should commit this)
```
charlock_holmes (0.7.9)
```

To get all migrations to run successfully I had to update this migration's version from `7.1` -> `7.0`
(was unsure if I should commit this)
```
class AddTrackableToBillingUsageTracker < ActiveRecord::Migration[7.0]
  def change
    add_column :billing_usage_trackers, :trackable_id, :bigint
    add_column :billing_usage_trackers, :trackable_type, :string, default: "Team"
    add_index :billing_usage_trackers, [:trackable_id, :trackable_type]
  end
end
```
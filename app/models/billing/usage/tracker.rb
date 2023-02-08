class Billing::Usage::Tracker < BulletTrain::Billing::Usage.base_class.constantize
  # e.g. `belongs_to :team`
  belongs_to BulletTrain::Billing::Usage.parent_association
  has_many :counts, dependent: :destroy

  if ActiveRecord::Base.connection.adapter_name.downcase.include?("mysql")
    after_initialize do
      self.usage ||= {}
    end
  end

  def self.cycles(parent)
    Billing::Usage::ProductCatalog.new(parent).cycles
  end

  def track(action, model, count)
    count_id = counts.find_or_create_by(action: action, name: model.to_s).id
    Billing::Usage::Count.update_counters(count_id, count: count, touch: true)

    usage[model.name] ||= {}
    usage[model.name][action.to_s] ||= 0
    usage[model.name][action.to_s] += count
    save
  end

  def cycle_as_needed
    return nil unless needs_cycling?
    team.billing_usage_trackers.create(duration: duration, interval: interval)
  end

  def needs_cycling?
    created_at + duration.send(interval) < Time.zone.now
  end
end

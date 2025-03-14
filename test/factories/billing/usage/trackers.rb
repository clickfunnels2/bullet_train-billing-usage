FactoryBot.define do
  factory :tracker, class: "Billing::Usage::Tracker" do
    duration { 1 }
    interval { "month" }
    association :team
    association :trackable, factory: :team
  end
end

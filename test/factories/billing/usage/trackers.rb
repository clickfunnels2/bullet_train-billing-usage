FactoryBot.define do
  factory :tracker, class: "Billing::Usage::Tracker" do
    duration { 1 }
    interval { "month" }
    team_id { create(:team).id }
    association :trackable, factory: :team
  end
end

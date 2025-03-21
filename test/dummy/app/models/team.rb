class Team < ApplicationRecord
  include Billing::Usage::HasTrackers

  validates :name, presence: true

  def team
    self
  end

  def workspace
    OpenStruct.new(id: 1)
  end
end

class Ping < ApplicationRecord
  scope :at, ->(since:, till:) { where('CREATED_AT BETWEEN ? AND ?', since, till) }
  scope :lost, -> { where(rtt: nil) }
  scope :round_trip, -> { where.not(rtt: nil) }

  validates :ip, presence: true
end

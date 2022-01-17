class IpTrackingInterval < ApplicationRecord
  scope :open, -> { where(till: nil) }

  validates :ip, :since, presence: true
end

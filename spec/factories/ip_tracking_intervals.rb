FactoryBot.define do
  factory :ip_tracking_interval, class: IpTrackingInterval do
    ip { Faker::Internet.ip_v4_address }
    since { 10.minutes.ago }
  end
end

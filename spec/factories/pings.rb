FactoryBot.define do
  factory :ping, class: Ping do
    rtt { rand(100) }
    ip { Faker::Internet.ip_v4_address }

    trait :lost do
      rtt { nil }
    end
  end
end

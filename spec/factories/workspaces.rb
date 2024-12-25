require 'securerandom'

FactoryBot.define do
  factory :workspace do
    sequence(:name) { "#{n}-name" }
    sequence(:token) { |n| "#{n}#{SecureRandom.hex}" }
  end
end

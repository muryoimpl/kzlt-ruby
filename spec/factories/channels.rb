require 'securerandom'

FactoryBot.define do
  factory :channel do
    sequence(:name) { |n| "#{n}-channel" }
    sequence(:channel_id) { |n| "#{n}-#{SecureRandom.uuid}" }
  end
end

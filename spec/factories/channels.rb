require 'securerandom'

FactoryBot.define do
  factory :channel do
    sequence(:name) { |n| "#{n}-channel" }
    sequence(:slack_channel_id) { |n| "#{n}-#{SecureRandom.uuid}" }
  end
end

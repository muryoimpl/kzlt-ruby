# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :workspace do
    sequence(:name) { |n| "#{n}-name" }
    sequence(:slack_team_id) { |n| "T#{n}#{SecureRandom.hex}" }
  end
end

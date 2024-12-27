# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :workspace do
    sequence(:name) { |n| "#{n}-name" }
    sequence(:token) { |n| "#{n}#{SecureRandom.hex}" }
  end
end

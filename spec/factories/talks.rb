# frozen_string_literal: true

FactoryBot.define do
  factory :talk do
    sequence(:title) { |n| "my title:#{n}" }
    status { 'unordered' }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :entry do
    sequence(:title) { |n| "my title:#{n}" }
    status { 'unordered' }
  end
end

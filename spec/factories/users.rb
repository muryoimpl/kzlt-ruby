require 'securerandom'

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "kzlt.ruby.#{n}" }
    slack_user_id { SecureRandom.uuid }
  end
end

# frozen_string_literal: true

module Api
  class SlackJsonSerializer
    include Alba::Resource

    attributes :response_type
    attribute :username do |_|
      "kzrb"
    end
    attribute :text do |resource|
      resource.message
    end
  end
end

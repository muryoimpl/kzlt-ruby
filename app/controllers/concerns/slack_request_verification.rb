# frozen_string_literal: true

module SlackRequestVerification
  extend ActiveSupport::Concern

  VERSION_NUMBER = "v0"
  TIMESTAMP_KEY = "X-Slack-Request-Timestamp"
  SIGNATURE_KEY = "X-Slack-Signature"

  included do
    before_action :verify_request
  end

  def verify_request
    signing_signature = ENV["APP_SLACK_SIGNING_SECRET"]

    base_str = [ VERSION_NUMBER, request.headers[TIMESTAMP_KEY], request.body.string.gsub("+", "%20") ].join(":")
    hexdigest = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha256"),
      signing_signature,
      base_str
    )
    my_sig = "#{VERSION_NUMBER}=#{hexdigest}"

    render plain: "Forbidden", status: :forbidden if my_sig != request.headers[SIGNATURE_KEY]
  end
end

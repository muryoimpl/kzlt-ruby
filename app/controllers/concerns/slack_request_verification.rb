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

    base_str = [ VERSION_NUMBER, request.headers[TIMESTAMP_KEY], request.body.string ].join(":")

    hexdigest = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha256"),
      signing_signature,
      base_str
    )
    my_sig = "#{VERSION_NUMBER}=#{hexdigest}"

    if ENV["DEBUG"].to_i == 1
      Rails.logger.info("request.body.string: #{request.body.string}")
      Rails.logger.info("raw_post class: #{request.raw_post.class}, value: #{request.raw_post}, method_symbol: #{request.method_symbol}")
      Rails.logger.info("my_sig: #{my_sig}")
      Rails.logger.info("header: x-slack-signature:#{request.headers[SIGNATURE_KEY]}, x-slack-request-timestamp: #{request.headers[TIMESTAMP_KEY]}")
      params.permit!
      Rails.logger.info("params: #{params.to_h}")
    end

    render plain: "Forbidden", status: :forbidden if my_sig != request.headers[SIGNATURE_KEY]
  end
end

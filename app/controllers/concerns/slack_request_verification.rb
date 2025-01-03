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
      hash = {
        token: params[:token],
        team_id: params[:team_id],
        team_domain: params[:team_domain],
        channel_id:  params[:channel_id],
        channel_name: params[:channel_name],
        user_id: params[:user_id],
        user_name: params[:user_name],
        command: params[:command],
        text: params[:text],
        api_app_id: params[:api_app_id],
        response_url: params[:response_url],
        trigger_id: params[:trigger_id]
      }
      Rails.logger.info("params: #{hash}")
    end

    render plain: "Forbidden", status: :forbidden if my_sig != request.headers[SIGNATURE_KEY]
  end
end

# frozen_string_literal: true

module SlackRequestVerification
  module Testing
    def hmac_digest(params)
      signing_signature = ENV["APP_SLACK_SIGNING_SECRET"]

      body_str = params.slice(
                   :token, :team_id, :team_domain, :enterprise_id,
                   :enterprise_name, :channel_id, :channel_name,
                   :user_id, :user_name, :command, :text, :response_url,
                   :trigger_id, :api_app_id
                 ).map { |k, v| v.nil? ? k.to_s : "#{k}=#{ERB::Util.u(v)}" }.join("&")
      base_str = [ ::SlackRequestVerification::VERSION_NUMBER, signatured_at, body_str ].join(":")
      hexdigest = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new("sha256"),
        signing_signature,
        base_str
      )

      "#{VERSION_NUMBER}=#{hexdigest}"
    end

    def signatured_at
      @signatured_at ||= Time.current.to_i
    end
  end
end

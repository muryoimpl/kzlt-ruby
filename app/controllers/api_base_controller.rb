# frozen_string_literal: true

class ApiBaseController < ApplicationController
  rescue_from StandardError, with: :render_500

  include SlackRequestVerification
  include SlackRequestFilter

  private

  def render_500(e)
    backtrace_str = e.backtrace.join("\n")
    render plain: "#{e.class}, #{e.message}: #{backtrace_str}"
  end
end

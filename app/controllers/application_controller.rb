# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :validate_requested_token
  before_action :validate_command

  private

  def validate_requested_token
    @workspace = Workspace.find_by(token: params[:token])

    if @workspace.blank?
      render plain: "Invalid token", status: :unauthorized
    end
  end

  def validate_command
    unless params[:command].strip.match?(/\A\/kzlt\z/)
      render plain: "Invalid command", status: :bad_request
    end
  end
end

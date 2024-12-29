# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :validate_requested_team_id
  before_action :validate_command

  private

  def validate_requested_team_id
    @workspace = Workspace.find_by(slack_team_id: params[:team_id])

    if @workspace.blank?
      render plain: "Invalid team_id", status: :unauthorized
    end
  end

  def validate_command
    unless params[:command].strip.match?(/\A\/kzlt\z/)
      render plain: "Invalid command", status: :bad_request
    end
  end
end

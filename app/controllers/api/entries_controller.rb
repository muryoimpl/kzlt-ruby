# frozen_string_literal: true

module Api
  class EntriesController < ApplicationController
    def create
      parsed = CommandParser.parse(params[:text])

      executor = CommandExecutor.new(
                   command: parsed.command,
                   argument: parsed.argument,
                   workspace: @workspace,
                   params: entry_params
                 )

      response = executor.execute

      render json: ::Api::SlackJsonSerializer.new(response).serialize
    rescue CommandParser::ParseError
      render plain: Help::TEXT
    rescue ActiveRecord::RecordInvalid => e
      render plain: "#{e.record.errors.full_messages.join("\n")}"
    rescue StandardError => e
      message = "処理中にエラーが発生しました。#{e.class} #{e.message}\n#{e.backtrace.join("\n")}"
      render plain: message
    end

    private

    def entry_params
      params.permit(
        :team_id,
        :channel_id,
        :channel_name,
        :user_id,
        :user_name,
        :command,
        :text
      )
    end
  end
end

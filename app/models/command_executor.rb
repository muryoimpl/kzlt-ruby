# frozen_string_literal: true

class CommandExecutor
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :command, :string
  attribute :argument, :string
  attribute :workspace
  attribute :params

  def execute
    ApplicationRecord.transaction do
      channel = find_or_create_channel
      user = find_or_create_user

      Executor.commanders[command].new(
        command:,
        argument:,
        channel:,
        user:
      ).execute
    end
  end

  private

  def find_or_create_channel
    workspace.channels.find_or_create_by!(slack_channel_id: params[:channel_id]) do |c|
      c.name = params[:channel_name]
    end
  end

  def find_or_create_user
    user = ::User.find_or_create_by!(slack_user_id: params[:user_id]) do |user|
      user.name = params[:user_name]
    end
    user
  end
end

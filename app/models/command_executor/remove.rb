# frozen_string_literal: true

class CommandExecutor
  class Remove < Executor
    def execute
      entry = channel.entries.find(argument)
      if user != entry.user
        return CommandExecutor::Response.new(message: unauthorized_message, is_private: true)
      end

      @title = entry.title
      entry.destroy!

      CommandExecutor::Response.new(message:)
    rescue ActiveRecord::RecordNotFound
      CommandExecutor::Response.new(message: not_found_message, is_private: true)
    end

    private

    def message
      "LT title: #{@title} のエントリが取り消されました。"
    end

    def not_found_message
      "entry 時に返ってきた entryId を指定してください /kzlt remove 1"
    end

    def unauthorized_message
      "entry が自身のものではありません。 #{user.name}"
    end
  end
end

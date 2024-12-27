# frozen_string_literal: true

class CommandExecutor
  class Entry < Executor
    def execute
      @entry = channel.entries.create!(user:, title: argument)
      CommandExecutor::Response.new(message:)
    end

    private

    def message
      "#{username} さんから LT:「#{title}」のエントリがありました。entryId: #{@entry.id}"
    end

    def username
      user.name
    end

    def title
      argument
    end
  end
end

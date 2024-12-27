# frozen_string_literal: true

class CommandExecutor
  class My < Executor
    def execute
      @entries = user.entries.joins(:channel)
                             .where(channels: { id: channel.id })
                             .where.not(status: :removed)
                             .order(:id)

      CommandExecutor::Response.new(message:)
    end

    private

    def message
      lines = @entries.map { |entry| "- #{entry.title}, entryId: #{entry.id}" }.join("\n")

      <<~MSG
        #{user.name}のエントリー
        #{lines}
      MSG
    end
  end
end

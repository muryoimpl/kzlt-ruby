# frozen_string_literal: true

class CommandExecutor
  class Delimit < Executor
    def execute
      channel.entries.where(status: %i[ordered unordered]).update_all(status: :delimited)

      CommandExecutor::Response.new(message:)
    end

    private

    def message
      "ここまで順番を決めたエントリは発表済みとみなします"
    end
  end
end

# frozen_string_literal: true

class CommandExecutor
  class List < Executor
    def execute
      @entries = channel.entries.unordered.eager_load(:user).order(:id)

      return CommandExecutor::Response.new(message:) if @entries.present?

      CommandExecutor::Response.new(message: no_entry_message, is_private: true)
    end

    private

    def message
      lines = @entries.map do |entry|
        "- #{entry.title} by #{entry.user.name}, entryId: #{entry.id}"
      end.join("\n")

      <<~MSG
        現在までのエントリー: #{@entries.size} 件
        #{lines}
      MSG
    end
  end
end

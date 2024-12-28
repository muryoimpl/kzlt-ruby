# frozen_string_literal: true

class CommandExecutor
  class All < Executor
    def execute
      @entries = channel.entries.eager_load(:user)
                                .where(status: %i[unordered ordered delimited])
                                .order(:id)

      return CommandExecutor::Response.new(message:, is_private: true) if @entries.present?
      CommandExecutor::Response.new(message: no_entry_message, is_private: true)
    end

    private

    def message
      @entries.map do |entry|
        "- #{badge(entry)}#{entry.title} by #{entry.user.name}, entryId: #{entry.id}"
      end.join("\n").concat("\n")
    end

    def badge(entry)
      %w[delimited ordered].include?(entry.status) ? "[done] " : ""
    end
  end
end

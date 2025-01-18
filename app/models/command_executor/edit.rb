# frozen_string_literal: true

class CommandExecutor
  class Edit < Executor
    def execute
      @entry_id, @title = parse_argument

      if @entry_id.blank? || @title.blank?
        return CommandExecutor::Response.new(message: error_message, is_private: true)
      end

      entry = channel.entries.where(status: %w[unordered ordered]).find_by(id: @entry_id)
      if entry.nil?
        return CommandExecutor::Response.new(message: error_message, is_private: true)
      end

      if user != entry.user
        return CommandExecutor::Response.new(message: unauthorized_message, is_private: true)
      end

      entry.update!(title: @title)
      CommandExecutor::Response.new(message:)
    end

    private

    def parse_argument
      pos = argument&.index(/\s+/).to_i
      return if pos.zero?

      entry_id = argument[0..(pos - 1)]
      title = argument[pos..-1].strip

      [ entry_id, title ]
    end

    def message
      "#{user.name} の entryId: #{@entry_id} のタイトルが 『#{@title}』 に更新されました。"
    end

    def error_message = "ID とタイトルを指定してください /kzlt edit <entryId> title"

    def unauthorized_message = "entry が自身のものではありません。 #{user.name}"
  end
end

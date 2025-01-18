# frozen_string_literal: true

class CommandExecutor
  class Self < Executor
    def execute
      CommandExecutor::Response.new(message:, is_private: true)
    end

    private

    def message
      "username: #{user.name}"
    end
  end
end

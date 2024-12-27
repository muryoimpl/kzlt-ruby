# frozen_string_literal: true

class CommandExecutor
  class Response
    attr_reader :message, :is_error

    def initialize(message:, is_error: false)
      @message = message
      @is_error = is_error
    end
  end
end

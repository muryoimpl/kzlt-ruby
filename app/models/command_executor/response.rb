# frozen_string_literal: true

class CommandExecutor
  class Response
    attr_reader :message

    def initialize(message:)
      @message = message
    end
  end
end

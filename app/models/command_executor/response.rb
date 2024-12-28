# frozen_string_literal: true

class CommandExecutor
  class Response
    attr_reader :message, :is_private

    def initialize(message:, is_private: false)
      @message = message
      @is_private = is_private
    end
  end
end

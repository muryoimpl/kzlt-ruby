# frozen_string_literal: true

class CommandExecutor
  class Executor
    @commanders = {}
    def self.commanders
      @commanders
    end

    def self.inherited(klass)
      key = klass.name.split("::").last
      klass.superclass.commanders[key] = klass
    end

    attr_reader :command, :argument, :channel, :user

    def initialize(command:, argument:, channel:, user:)
      @command = command
      @argument = argument
      @channel = channel
      @user = user
    end

    def execute
      raise NotImplementedError
    end
  end
end

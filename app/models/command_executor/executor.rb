# frozen_string_literal: true

class CommandExecutor
  class CommandMismatchError < StandardError; end

  class Executor
    @commanders = {}
    def self.commanders
      @commanders
    end

    def self.inherited(klass)
      key = klass.name.split("::").last.downcase
      klass.superclass.commanders[key] = klass
    end

    attr_reader :command, :argument, :channel, :user

    def initialize(command:, argument:, channel:, user:)
      @command = command
      @argument = argument
      @channel = channel
      @user = user

      assert_command!
    end

    def execute
      raise NotImplementedError
    end

    def no_entry_message
      "エントリーはありません"
    end

    def assert_command!
      raise ::CommandExecutor::CommandMismatchError if @command != self.class.name.split("::").last.downcase
    end
  end
end

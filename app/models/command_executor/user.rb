# frozen_string_literal: true

class CommandExecutor
  class User < Executor
    def execute
      @name_was = user.name
      @user = ::User.find(user.id)
      @user.update!(name: argument)

      CommandExecutor::Response.new(message:, is_private: true)
    end

    private

    def message
      "name を「#{@name_was}」から「#{@user.name}」に変更しました。"
    end
  end
end

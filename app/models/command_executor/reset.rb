# frozen_string_literal: true

class CommandExecutor
  class Reset < Executor
    def execute
      entries = channel.entries.where(status: "ordered")

      entries.update_all(status: :unordered) if entries.present?

      CommandExecutor::Response.new(message:, is_private: true)
    end

    private

    def message
      "エントリーの順番を決めていない状態に戻しました"
    end
  end
end

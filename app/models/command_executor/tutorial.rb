# frozen_string_literal: true

class CommandExecutor
  class Tutorial < Executor
    MESSAGE = <<~MSG
      まず初めに、1 から 3 の順にコマンドを入力して表示名を指定しましょう。
      その後に、4 で LT をエントリしましょう。

      1. `/kzlt self` を実行して、まず自分の登録名を確認してください。
      2. `/kzlt user <name>` を実行して、自分の登録名を更新してください。
      3. `/kzlt self` を再度実行して、変更されていることを確認します。
      4. `/kzlt entry <title>` を実行して、自分の発表するLTのタイトルを登録してください。
    MSG

    def execute
      CommandExecutor::Response.new(message: MESSAGE, is_private: true)
    end
  end
end

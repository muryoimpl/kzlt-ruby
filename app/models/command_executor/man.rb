# frozen_string_literal: true

class CommandExecutor
  class Man < Executor
    MAN = <<~MSG
      初めての方向けに、以下のコマンドを入力して実行することを理解してもらいましょう

      `/kzlt tutorial`: 名前の表示変更手順、entry の登録を理解します

      tutorial を確認したらエントリを始めます。

      1. `/kzlt entry <title>` で発表者にエントリしてもらいます
      2. `/kzlt edit <entryId> <title>` で自分の登録済タイトルを変更できます
      3. `/kzlt list` で順番を決めていないエントリをすべて表示します
      4. `/kzlt shuffle` で発表順番を決めます
      5. `/kzlt delimit` で 1 周目のエントリを区切ります

      決めた順番に従って発表します。

      1 から 5 を繰り返します。
    MSG

    def execute
      CommandExecutor::Response.new(message: MAN, is_private: true)
    end
  end
end

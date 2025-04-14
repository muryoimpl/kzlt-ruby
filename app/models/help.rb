# frozen_string_literal: true

class Help
  TEXT = <<~HELP
    /kzlt tutorial                -- 初めての場合に、まず実行すべきコマンドを教えてくれます 【非公開出力】
    /kzlt man                     -- 運営する人向けに、大雑把な実行の流れを教えてくれます 【非公開出力】
    /kzlt self                    -- 自分の登録名を出力する 【非公開出力】
    /kzlt user <name>             -- 自分の登録名を更新する 【非公開出力】
    /kzlt entry <title>           -- 自分のLTを登録する。※ title 中にスペースありでも '' で囲む必要なし
    /kzlt edit <entryId> <title>  -- 自分のLTを登録する。※ title 中にスペースありでも '' で囲む必要なし
    /kzlt my                      -- 自分のエントリしたLTを自分にだけ表示する 【非公開出力】
    /kzlt list                    -- エントリー済みのLTをchannelに出力する(順番を決めたものを除く)
    /kzlt all                     -- エントリー済みのLTを出力する(順番決めた/決めてない関係なく)  【非公開出力】
    /kzlt shuffle                 -- 順番を決め、channelに出力する
    /kzlt shuffle <seed>          -- 指定した seed で順番を決め、channelに出力する (reset 後の再現用)
    /kzlt reset                   -- 順番決めたものすべてを順番決めていないことにする 【非公開出力】
    /kzlt remove <entryId>        -- エントリ時に返ってきた番号を指定してエントリを削除する
    /kzlt delimit                 -- 一旦区切ってすでに順番を決めたエントリをshuffle対象外とする
    ※ delimit 後に shuffle することで、前回 shuffle 後にエントリしたものだけで shuffle できます
  HELP
end

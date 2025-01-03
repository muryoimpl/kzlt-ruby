# frozen_string_literal: true

class Help
  TEXT = <<~HELP
    /kzlt entry <title>    -- 自分のLTを登録する。※ スペースありでも '' で囲む必要なし
    /kzlt my               -- 自分のエントリしたLTを自分にだけ表示する
    /kzlt list             -- エントリー済みのLTをchannelに出力する(順番を決めたものを除く)
    /kzlt all              -- エントリー済みのLTを出力する(順番決めた/決めてない関係なく)
    /kzlt shuffle          -- 順番を決め、channelに出力する (次のshuffleに出てこない)
    /kzlt shuffle <seed>   -- 指定した seed で順番を決め、channelに出力する (次のshuffleに出てこない)
    /kzlt reset            -- 順番決めたものすべてを順番決めていないことにする
    /kzlt remove <entryId> -- エントリ時に返ってきた番号を指定してエントリを削除する
    /kzlt delimit          -- 一旦区切ってすでに順番を決めたエントリをshuffle対象外とする
    ※ delimit 後に shuffle することで、前回 shuffle 後にエントリしたものだけで shuffle できます
  HELP
end

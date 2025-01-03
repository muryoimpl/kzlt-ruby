# kzlt-ruby

Kanazawa.rb の LT 大会向け Slack Slash command `KZLT` の Backend 実装です。

## 環境変数

- APP_SLACK_SIGNING_SECRET
    - Slack の signing_secret
- LITESTREAM_REPLICA_BUCKET
    - Litestream がファイルを保存する bucket 名
- DEBUG
    - パラメータの debug 出力 ON/OFF (`1` で ON)
- RAILS_MASTER_KEY
- RAILS_ENV

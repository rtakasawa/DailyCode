### [ECSのアプリケーションを正常にシャットダウンする方法](https://aws.amazon.com/jp/blogs/news/graceful-shutdowns-with-ecs/)で紹介されているSIGTERMシグナルを処理するShellハンドラーの解読
- 以下シェルスクリプトを確認すると、以下の処理を行っている。
  1. 「標準出力をstdout.logへ、標準エラーをstderr.logへ出力」処理を実行 
  2. ECSからSIGTERMシグナルが送信された場合に、iの処理にTERMシグナルを送って、iを終了する
```shell
#!/bin/sh
set -x

# ＜ここでやっていること＞
# /log/stdout.logを、/proc/$$/fd/1のショートカットとしている
# ＜コマンドの説明＞
# ln [オプション] リンク元　[リンク先]
# -f	指定したリンクファイルが存在した場合は、既存のリンクを強制的に削除する
# -s	ハードリンクではなく、シンボリックリンクを作成する
# $$はシェル自身のプロセスID
ln -sf /proc/$$/fd/1 /log/stdout.log
ln -sf /proc/$$/fd/2 /log/stderr.log

# コンテナ立ち上げ時の処理
pre_execution_handler() {
  :
}

# Post execution handlerメソッドは、クリーンアップコードとして使われている
# クリーンアップコード：実行時に開いているファイルやデータベースの接続などを適切に閉じたり破棄することを指す
# ※参照先：https://program-shoshinsya.hatenablog.com/entry/2021/07/27/230442
# シェルスクリプトの終了時に必ず実行する処理という理解をした
post_execution_handler() {
  :
}

# ECSからSIGTERMシグナルが送信された場合に実行する処理
sigterm_handler() {
  # ＜ここでやっていること＞
  # pidが0の場合は、本シェルスクリプトの処理を終了する
  # pidが0ではない場合は、pidにTERMシグナルを送って、"$pid"のプロセスの終了後に、本シェルスクリプトの処理を終了する
  
  # pidが0ではない場合はtrue（-ne:等しくなければtrue）
  if [ $pid -ne 0 ]; then
    # "$pid"にTERMシグナルを送る（-15はTERMシグナル）
    kill -15 "$pid"
    # "$pid"のプロセスの終了を待つ
    wait "$pid"
    post_execution_handler
  fi
  # exit:処理を終了する
  exit 143; # 128 + 15 -- SIGTERM
}

# ＜ここでやっていること＞
# SIGTERMシグナルを受け取ったら、sigterm_handlerを実行する
# ＜コマンドの説明＞
# trap：シグナルを送出した際に、指定したコマンドを実行させる事ができる
# trap 'コマンド' [シグナル番号|シグナル名]
trap 'sigterm_handler' SIGTERM

# コンテナ立ち上げ時の処理
pre_execution_handler

# ＜ここでやっていること＞
# ①「標準出力をstdout.logへ、標準エラーをstderr.logへ出力」処理をバックグラウンドで実行
# ②①のプロセスIDをpidに格納
# ＜自分の理解＞
# TERMシグナルを送信したい処理を「>/log/stdout.log 2>/log/stderr.log "$@"」に入れるべきと理解した
# ＜コマンドの説明＞
# コマンドの後ろに&をつけて実行すると、コマンド（>/log/stdout.log 2>/log/stderr.log "$@"）がバックグラウンドで実行される
# $@：シェルスクリプトの実行時に渡された引数をすべて展開または関数に渡された引数をすべて展開する変数として利用できる
# $!：バックグラウンドで実行された直前のプロセスのプロセス番号を保持
>/log/stdout.log 2>/log/stderr.log "$@" &
pid="$!"

# "$pid"のプロセスが終了するまで、本シェルスクリプトのプロセスは残り続ける
# なぜなら、SIGTERMシグナルを受け取るため
wait "$pid"
# シェルが最後に実行したコマンドの終了状態を保持している。ほとんどのコマンドは成功時には「0」を返す
return_code="$?"

post_execution_handler

# 本シェルスクリプトの処理を終了する
exit $return_code
```

### 上記シェルスクリプトを参考に、Sidekiqコンテナを正常に終了するシェルスクリプトを作成（動作確認未）
- 以下の処理を実装
  1. sidekiqを起動 
  2. ECSからSIGTERMシグナルが送信された場合に、iにTERMシグナルを送信し、iを終了する
```shell
#!/bin/sh
set -x

sigterm_handler() {
  # sidekiqの実行プロセスにTERMシグナルを送信する
  if [ $pid -ne 0 ]; then
    kill -15 "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

trap 'sigterm_handler' SIGTERM

# ①バックグラウンドでsidekiqを起動（jobの実行は①のプロセスで行われるはず・・・）
# ②pidに①のプロセスidを入れる
bundle exec sidekiq &
pid="$!"

wait "$pid"
return_code="$?"
exit $return_code
```



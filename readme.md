# Tips

## Category
### [良いコードを書くためのチェックリスト](https://github.com/rtakasawa/DailyCode/blob/master/code_style_check_sheet.md)

### [リーダブルコード（まとめ）](https://github.com/rtakasawa/DailyCode/blob/master/readable_code.md)

### code design
- クラスで分岐するケース文のリファクタリング
  - [code](https://github.com/rtakasawa/DailyCode/blob/master/code_design/case_statement_branch_by_class.rb)

- 引数の順番を覚えなる責務をなくす方法
  - [code](https://github.com/rtakasawa/DailyCode/blob/master/code_design/argument.rb)

### Rails
- [Valueオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/value_object.md)
- [サービスオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/service_object.md)
- [Formオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/form_object.md)
- [共通のバリデーションルールを定義](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/validator.md)
- 複雑なデータ操作
  - [Concern](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/concern.md)

### design_pattern
- アダプタ
  - using_scene
    - 既存のクラスやメソッドを、変更して使いたい。（現状の使用箇所に影響がないように）
    - 既存のクラスやメソッドを、使用できない場所も使いたい。（現状の使用箇所に影響がないように）
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/adapter.rb)
- アブストラクトファクトリー
  - using_scene
    - 関連するオブジェクトをまとめて生成する必要があるとき
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/abstract_factory.rb)
- Builder
  - using_scene
    - オブジェクトを作る時に大量の処理が必要な場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/builder.rb)
- Command
  - using_scene
    - 特定のタスクを実行したい場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/command.rb)
- Composite
  - using_scene
    - 階層構造で表現されるオブジェクトの場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/conposite.rb)
- Decorator
  - using_scene
    - 既存オブジェクトに機能を追加したい場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/decorator.rb) 
- ファクトリーメソッド<br>
  - using_scene
    - オブジェクトを作成するプロセスが共通している場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/factory_method.rb)
    - [image](https://github.com/rtakasawa/DailyCode/blob/master/images/factory_method.png)
  - practice
    - [code](https://github.com/rtakasawa/DailyCode/blob/3ee6d64c273226123fa9de808b41b83e2fca9f40/design_pattern/factory_method_practice.rb)
    - [image](https://github.com/rtakasawa/DailyCode/blob/3ee6d64c273226123fa9de808b41b83e2fca9f40/images/factory_method_practice.png)
- Interpreter
  - using_scene
    - 構造木に沿った処理を実現する場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/interpreter.rb)
- Iterator
  - using_scene
    - 要素の集まったオブジェクト（配列等）にアクセスする場合
    - 集合の要素に順にアクセスする必要がある
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/iterator.rb)
- Observer
  - using_scene
    - 次の条件を満たす場合にオブザーバパターンを使う。
      - オブジェクトの状態が変化する可能性がある
      - 変化したことをほかのオブジェクトに通知する必要がある
    - ※例:Aで起きたイベントをB, Cが知る必要がある場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/observer.rb)
- Proxy
  - using_scene
    - 1つのオブジェクトに複数の関心事がある場合に、関心事を分離するために使う
    - オブジェクトの本質的な目的とは異なる要件を分離できる
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/proxy.rb)
- Strategy
  - using_scene
    - オブジェクト内に複雑なアルゴリズムがある場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/strategy.rb)
- Singleton
  - using_scene
    - 一つだけに限定されたインスタンスを複数のオブジェクト内で共有する場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/singleton.rb)
- Template
  - using_scene
    - 2つのコードのやりたいこと（アルゴリズム）がほとんど同じで、一部を変えたい場合
  - sample
    - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/template.rb)

### 「Java言語で学ぶデザインパターン入門」をrubyに書き換え
- Strategy
  - [code](https://github.com/rtakasawa/DailyCode/blob/master/design_pattern/java_convert/strategy.rb)    

### Ruby / Rails
- RailsサーバとRedisとSidekiqの関係（図）
  - [image](https://github.com/rtakasawa/DailyCode/blob/9bf3b1960bc4360cad6fc97f2a9c2bfa60746754/images/rails_redis_sidekiq.png)
- [既存テーブルにNOT NULL制約有のカラムを追加する場合のmigrationファイルの書き方（gem`paranoia`使用時）](https://github.com/rtakasawa/DailyCode/blob/master/ruby/db/add_not_null_column_use_paranoia.md)

#### File
- zip_fileを解凍して,中身（file）をDB（ActiveStorage）に保存する
  - [code](https://github.com/rtakasawa/DailyCode/blob/master/ruby/File/unzip.rb)

#### 正規表現
- [Tips](https://github.com/rtakasawa/DailyCode/blob/master/ruby/regexp.md)

### AWS
#### ECS
- [SIGTERMシグナルを処理するShellハンドラーの解読](https://github.com/rtakasawa/DailyCode/blob/master/bash/graceful-shutdowns-with-ecs.md)
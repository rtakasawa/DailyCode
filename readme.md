# Tips

## Category
### code design
- クラスで分岐するケース文のリファクタリング
  - [code](https://github.com/rtakasawa/DailyCode/blob/master/code_design/case_statement_branch_by_class.rb)

- 引数の順番を覚えなる責務をなくす方法
  - [code](https://github.com/rtakasawa/DailyCode/blob/master/code_design/argument.rb)

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

### Ruby
- RailsサーバとRedisとSidekiqの関係（図）
  - [image](https://github.com/rtakasawa/DailyCode/blob/9bf3b1960bc4360cad6fc97f2a9c2bfa60746754/images/rails_redis_sidekiq.png)

#### File
- zip_fileを解凍して,中身（file）をDB（ActiveStorage）に保存する
  - [code](https://github.com/rtakasawa/DailyCode/blob/master/ruby/File/unzip.rb)
# Railsのデザインパターンまとめ

## Controller
### ユーザからの入力を整形、検証、保存、更新の複雑な処理
- [Formオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/form_object.md)

## Model
### 複数modelを使用するドメインロジック
- [サービスオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/service_object.md)
- [Interactorオブジェクト](https://applis.io/posts/rails-design-patterns#interactor%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88)もある
### 複数modelで共通の属性を使用する場合
- [Valueオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/value_object.md)
### 複数modelで同じバリデーションを定義する場合
- [共通のバリデーションルールを定義](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/validator.md)
## View
### モデルに対するビューのロジックをカプセル化
- [DecoratorとPresenter](https://tech.kitchhike.com/entry/2018/02/28/221159)
### 再利用性のあるビューを、ビジネスロジックごとカプセル化する
- [View Componentオブジェクト](https://applis.io/posts/rails-design-patterns#view-component%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88)

## その他
### データ操作のロジック,関連付け（アソシエーション）の宣言を行うレイヤー
- [Concern](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/concern.md)
- データ操作のロジックだと、[Queryオブジェクト](https://applis.io/posts/rails-design-patterns#query%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88)もある
### 通知に関するロジック（例：Slack,LINE等）
- [Deliveryオブジェクト](https://applis.io/posts/rails-design-patterns#decorator%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88)
### ビジネスルールのカプセル化（例：ユーザの役割に応じて処理を実行する権限をもつかどうかを判断等）
- [Policyオブジェクト](https://applis.io/posts/rails-design-patterns#policy%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88)

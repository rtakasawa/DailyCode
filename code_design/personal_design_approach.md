# Wip:Railsの個人的な設計に関する考え方

## Controller
### ユーザからの入力を整形、検証、保存、更新の複雑な処理
- [Formオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/form_object.md)

## Model
## 複数テーブルを使用するドメインロジック
- [サービスオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/service_object.md)を使用することで、良いかと思う。
    - 理由は以下のとおり
        - ControllerとModelの中間層として、RailsのMVCに後からでも導入しやすい
        - チームメンバーのスキル感によらず、設計方針を理解して従うことができる

### 複数modelで共通の属性を使用する場合
- [Valueオブジェクト](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/value_object.md)

### 同じバリデーションを定義する場合
- [共通のバリデーションルールを定義](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/validator.md)

## View
- [Decoratorオブジェクト](https://applis.io/posts/rails-design-patterns#decorator%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88)

## その他
- [Concern](https://github.com/rtakasawa/DailyCode/blob/master/code_design/rails/concern.md)
- [Deliveryオブジェクト](https://applis.io/posts/rails-design-patterns#decorator%E3%82%AA%E3%83%96%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88)

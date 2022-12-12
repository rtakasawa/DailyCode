# サービスオブジェクト
## サービスオブジェクトとは
- 複数のオブジェクトを組み合わせて表現するロジック
- 上記のロジックを独立したオブジェクトとして定義したもの

## いつ導入するべきか
### 実装例
- BankAccount（口座残高）モデルを例に説明
- Moneyクラスは値オブジェクト
```ruby
# app/models/bank_account.rb

# == Schema Information
#
# Table name: bank_accounts
#
#  id         :bigint           not null, primary key
#  balance    :decimal(19, 4)   not null
#  currency   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BankAccount < ApplicationRecord
  composed_of :balance, class_name: "Money", mapping: [%w[balance amount], %w[currency currency]]

  # 預金
  def deposit(money)
    with_lock { update!(balance: balance + money) }
  end

  # 引き出す
  def withdraw(money)
    with_lock do
      raise "Withdrawal amount must not be greater than balance" if money > balance
      update!(balance: balance - money)
    end
  end
end
```

```ruby
# app/models/money.rb

class Money
  include Comparable

  attr_reader :amount, :currency
  alias eql? ==

  def initialize(amount, currency = :JPY)
    @amount = BigDecimal(amount)
    raise "Amount must not be negative" if @amount.negative?

    @currency = currency.to_sym
  end

  def <=>(other)
    return nil if self.class != other.class || currency != other.currency
    amount <=> other.amount
  end

  def +(other)
    raise "Currency is different" unless currency == other.currency
    self.class.new(amount + other.amount, currency)
  end

  def -(other)
    raise "Currency is different" unless currency == other.currency
    self.class.new(amount - other.amount, currency)
  end

  def hash
    [amount, currency].hash
  end
end
```

#### 追加機能
- 口座の送金ロジックを追加する
- ロジックは以下のとおり、複数の口座オブジェクトの状態を更新することになる
```ruby
def transfer_money
  from.withdraw(money)
  to.deposit(money)
end
```

#### サービスオブジェクト導入
```ruby
# app/services/transfer_money_between_bank_account_service.rb

class TransferMoneyBetweenBankAccountsService
  private_class_method :new

  def self.call(**kwargs)
    new.call(**kwargs)
  end

  def call(from:, to:, money:)
    from.transaction do
      from.withdraw(money)
      to.deposit(money)
    end
  end

  # private
  # 必要に応じて、callメソッド内の処理をプライベートメソッドとして抽出する
end
```

## 導入時のポイント
- モデルに実装すべきロジックまで実装しない
  - 引数のオブジェクトの属性の値を直接参照、更新している箇所は、モデルのインスタンスメソッドとして定義すべき
  - 上記を守らないと、モデルが持つべきロジックの詳細が分散して、再利用性、保守性が低下する
- イベントの見落としがないか確認する
  - 例えば、サービスオブジェクトのロジックを実行したことをDBに記録する必要がある場合、
    - サービスオブジェクトを導入する必要なし。
    - modelにロジックを書くこと、自然に実装できる。

## サービスオブジェクトの実装ルール
- class名を見て処理の概要が理解できるように命名する
- ドメインロジックを実行するクラスメソッドを1つだけ公開する
  - よく使われる名前
    - call
    - execute
    - perform
- privateメソッドを細かく切って処理の概要を理解しやすくする
- クラス外からはインスタンスが生成できないようにする
- 単一責任の原則を意識してService Objectを分割し、Service Objectの中で他のService Objectを呼び出す
- Rubyのプレーンなclass（PORO）で実装する

## サービスクラスのメリット
- ビジネスプロセスに細かい粒度で名前が与えられ、コードの可読性が向上する 
- 再利用性のある形で設計することも可能 
- チームメンバーのスキル感によらず、設計方針を理解して従うことができる 
- ControllerとModelの中間層として、RailsのMVCに後からでも導入しやすい 
- 引数と返り値の仕様が定まったclassになるので、テストを書きやすい

## 引用
- [パーフェクトRuby on Rails](https://gihyo.jp/book/2020/978-4-297-11462-6)
- [RailsでのService Objectの上手な使い方 ―Service Objectアンチパターン説の検討―](https://fuyu.hatenablog.com/entry/2022/10/19/232553)

## 参考
- [俺が悪かった。素直に間違いを認めるから、もうサービスクラスとか作るのは止めてくれ](https://qiita.com/joker1007/items/25de535cd8bb2857a685)
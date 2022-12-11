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
  - 


## 引用
- [パーフェクトRuby on Rails](https://gihyo.jp/book/2020/978-4-297-11462-6)
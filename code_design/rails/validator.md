# 共通のバリデーションルールを定義
## ActiveModel::EachValidator
### ユースケース
- 同じバリデーションを定義していることがある。 
  - 例：電話番号、メールアドレス、郵便番号、URL、カナなどのフォーマット

### メリット
- 1つの属性のバリデーションルールを、基底クラスに定義することで共通化できる

### 実装例：電話番号のバリデーションルールを定義
- ActiveModel::EachValidatorを継承したクラスでは、validate_eachというインスタンスメソッドにバリデーションルールを実装する
- 引数のrecord、attribute、valueにはそれぞれ、対象のオブジェクト、対象の属性、属性の値が入る
- options[:message]と書くことで、オプションとしてmessageパラメータの文字列が送られてきた時に、バリデーションメッセージを自由に設定することも出来る
```ruby
# app/validators/tel_format_validator.rb

class TelFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 電話番号のフォーマットかどうかを確認したいので、空文字は許可
    return if options[:allow_blank] && value.length.zero?

    # 固定電話と携帯番号(ハイフンなし10桁 or 11桁)を許可
    unless value =~ /\A\d{10}$|^\d{11}\z/
      record.errors[attribute] << (options[:message] || '電話番号の形式に誤りがあります')
    end
  end
end 
```
- 上のバリデーションルールの利用例
```ruby
# app/models/user.rb

class User < ApplicationRecord
  # モデルのvalidatesメソッドのオプションとして使える
  validates :tel, presence: true, tel_format: true
  validates :tel2, presence: true, tel_format: { message: '電話番号2の形式に誤りがあります' }
end
```

## ActiveModel::Validator
### ユースケース
- 複数の属性を組み合わせたバリデーションルールなど、より複雑なルールを定義する際に利用

### メリット
- 複数の属性を組み合わせたバリデーションルールを、基底クラスに定義することで共通化できる

### 実装例
- イベントを管理するモデルを考えて、そのイベントの開始日時（start_at）と終了日時（end_at）の差は24時間以内であるというケース
```ruby
# app/models/event.rb

# == Schema Information
#
# Table name: events
#
#  id                :bigint           not null, primary key
#  name              :string           default(""), not null
#  content           :text             default(""), not null
#  start_at          :datetime         not null
#  end_at            :datetime         not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null

class Organization < ApplicationRecord

  validates_presence_of %i(
    name
    content
    start_at
    end_at
  )
  validate :valide_difference_between_start_at_and_end_at

  private

  def valide_difference_between_start_at_and_end_at
    if (Time.zone.parse(end_at) - Time.zone.parse(start_at)) / 3600 > 24
      errors.add(:base, '開始日時と終了日時の差は24時間以内にしてください')
    end
  end
end
```
- 上記の`valide_difference_between_start_at_and_end_at`メソッドを以下のとおり切り出してみる
```ruby
# app/validators/event_range_validator.rb

class EventRangeValidator < ActiveModel::Validator
  # マジックナンバーは定数化する
  MAX_HOUR = 24
  SECONDS_OF_AN_HOUR = 3600

  def validate(record)
    if (Time.zone.parse(record.end_at) - Time.zone.parse(record.start_at)) / SECONDS_OF_AN_HOUR > MAX_HOUR
      # 特定の属性に属さないエラーはbaseに格納する
      record.errors.add(:base, '開始日時と終了日時の差は24時間以内にしてください')
    end
  end
end 
```
- 上記バリデーションルールを使ってみる（以下のとおり）
```ruby
# app/models/event.rb

# == Schema Information
#
# Table name: events
#
#  id                :bigint           not null, primary key
#  name              :string           default(""), not null
#  content           :text             default(""), not null
#  start_at          :datetime         not null
#  end_at            :datetime         not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null

class Organization < ApplicationRecord

  validates_presence_of %i(
    name
    content
    start_at
    end_at
  )
  validates_with EventRangeValidator, unless: -> { start_at.blank? || end_at.blank? }
end
```

### 引用
- [Railsでモデル層からバリデーションを切り出して共通のバリデーションルールを定義する ActiveModel::EachValidator編](https://tech.mof-mof.co.jp/blog/rails-each-validator/)
- [Railsでモデル層からバリデーションを切り出して共通のバリデーションルールを定義する ActiveModel::Validator編
  ](https://tech.mof-mof.co.jp/blog/rails-validator)
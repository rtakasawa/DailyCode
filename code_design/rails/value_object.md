# Valueオブジェクト
- Railsアプリケーションのコードをリファクタリングするためのデザインパターンのひとつ
- モデルが肥大化するFat Modelという問題を防ぐことができる

## Valueオブジェクトとは
- その名のとおり値を表すオブジェクト
- 値とはドメイン駆動設計という設計手法に登場する概念
- ドメイン駆動設計には、エンティティと値オブジェクトというふたつの概念が登場する


- エンティティ  
あるオブジェクトが持つ値が同じなら同一だと言えるもの
- 値オブジェクト  
同一性を判断できない情報

- エンティティと値オブジェクトの例
  - 人：エンティティ
  - 名前、住所：値オブジェクト

## なぜValueオブジェクトが必要か
- クラスを責務で分離し、コードをクリーンに保つために必要
- コードをクリーンに保つことで重複を排除し、テストが書きやすくなる
- Fat Modelの問題を解消することができる
- Valueオブジェクトを導入することで、オープン・クローズドの原則を守ることができる  
    ```
    # オープン・クローズドの原則
    あるクラスを修正するときに、他のクラスに影響が出ないような設計であること
    ```

## 例：ユーザー、管理者、ゲストユーザーが存在するアプリケーション
### Valueオブジェクト使用前
- 各クラスに`#full_name`メソッドを定義する必要あり
- 修正する場合も、各クラスのメソッドを1つ1つ修正する必要あり
```ruby
class User
  attr_reader :first_name, :last_name
  
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

class Admin
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

class Guest
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
```

### Valueオブジェクト使用後
- 『名前』をひとつのクラスに閉じ込めて、各クラスからはこのクラスを使うようにする
- ミドルネームが追加されたときもNameクラスを修正すればいいことになる
```ruby
class Name
  attr_reader :first_name, :last_name
  
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

class User
  def full_name
    name = Name.new(first_name, last_name)
    name.full_name
  end
end
```

## Valueオブジェクトの使い方（Railsアプリケーション）
- 『名前』に関するValueオブジェクトをRailsアプリケーションに導入してみる
- RailsのActiveRecord::Baseには`#composed_of`というメソッドがある
  - 複数のカラムを擬似的にひとつのカラムとして扱うためのメソッド
  - Valueオブジェクトを表すのに適している
### 実装例
```ruby
# ファイルは app/values 下に配置する
# ファイル名はValueオブジェクトの名前にする。ここでは name.rb
class Name
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
```

```ruby
class User < ApplicationRecord
  # 第一引数には属性名をシンボルで渡す。この属性名からクラス名を推測する。
  # ここでは :name なので Nameクラスを指定している

  # :mapping オプションでUserクラスとNameクラスの属性のマッピングを行う。
  # ここではUserクラスにおける first_name がNameクラスにおける first_name に対応する
  composed_of :name, mapping: [%w(first_name first_name), %w(last_name last_name)]
end
```

### 参考: Valueオブジェクトを用いた検索
- 上記のように`#composed_of`でValueオブジェクトを設定すると、Valueオブジェクトを用いた検索も行える
```ruby
users = User.where(name: Name.new('Taro', 'Yamada'))
```

## Valueオブジェクトのユースケース
- ある値が抽象化できる概念であり、かつ複数のクラスから属性として参照されるケースで利用する
- 例
  - 複数の値を組み合わせてひとつの値を算出するもの
    - 名前における姓名やミドルネーム
    - 住所における国や県・市区町村
  - 値の表現や比較を行うもの
    - 日付
    - 通貨
    - 気温
    - 商品のレビューにおける星の数

## いつValueオブジェクトを導入するか
- その値オブジェクトを複数のクラスから利用することになったら導入する

## Valueオブジェクトの設計上のルール
- ファイルは app/values 下に配置する 
- ファイル名はValueオブジェクトの名前にする。
  - たとえば name.rb
- 値オブジェクトをカプセル化する目的でつくる
- クラス名はなんの値オブジェクトかがわかるようにする。
  - たとえばNameやAddressなど。
  - NameValueのような接尾辞はつけない
- 必要最低限のインタフェースのみを公開する。
  - たとえば full_name など
- 公開したインタフェースに対するユニットテストを書く


## 引用
[Railsのデザインパターン: Valueオブジェクト](https://applis.io/posts/rails-design-pattern-value-objects)
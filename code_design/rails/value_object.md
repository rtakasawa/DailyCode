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


## 引用
[Railsのデザインパターン: Valueオブジェクト](https://applis.io/posts/rails-design-pattern-value-objects)
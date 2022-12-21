# 複雑なデータ操作
## Concern
- あるモデルやコントローラーを構成する一部のロジックを実装するモジュールを指す。
- `app/controllers/concerns`,`app/models/concerns`という2つのディレクトリが用意されている
- 複数のモデルやコントローラー間で、モジュールに実装したロジックを再利用できる

### 利用例
#### 利用前
```ruby
# app/models/photo.rb

# == Schema Information
#
# Table name: photos
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ApplicationRecord
  has_many :taggings, class_name: "#{name}Tagging"
  has_many :tags, through: :taggings

  def self.tagged_with(tag, *others, any: false)
    tags = [tag, *others]

    joins(:tags)
      .merge(reflect_on_association(:tags).klass.with_name(tags))
      .merge(
        if tags.size == 1
          all
        elsif any
          distinct
        else
          group(primary_key).having("COUNT(*) = ?", tags.size)
        end
      )
  end
end
```
#### 利用後
- `tagged_with`メソッドを他のモデルでも使用したい
- `tagged_with`メソッドをConcernとして抽出
```ruby
# app/models/concerns/taggable.rb

module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, class_name: "#{name}Tagging"
    has_many :tags, through: :taggings
  end

  class_methods do
    def tagged_with(tag, *others, any: false)
      tags = [tag, *others]

      joins(:tags)
        .merge(reflect_on_association(:tags).klass.with_name(tags))
        .merge(
          if tags.size == 1
            all
          elsif any
            distinct
          else
            group(primary_key).having("COUNT(*) = ?", tags.size)
          end
        )
    end
  end
end
```
```ruby
class Photo < ApplicationRecord
  include Taggable
end
```

### Concernを利用する前の検討事項
- modelの場合
  - 抽出したいロジックが値オブジェクトやサービスオブジェクトで実装するべきではないか考える
- controllerの場合
  - 抽出したいロジックがモデルやフォームオブジェクトで実装するべきではないか考える
- 上記で実装すべきでないロジックの場合に、Concernを利用する

### ユースケース
- データ操作のロジック
- 関連付け（アソシエーション）の宣言を行うレイヤー
- ルーティングにおいても共通の設定を再利用する仕組みがある。（`concern`メソッドを使う）

#### データ操作のロジック
- scopeをconcernを利用して共通化している。
  - 参考：[scope を ActiveSupport::Concern を利用して共通化する](https://qiita.com/QUANON/items/d57dc7a19870b88aa162)

#### 関連付け（アソシエーション）の宣言を行うレイヤー
- [mastdon](https://github.com/mastodon/mastodon)での使用例
  - [Accountモデル](https://github.com/mastodon/mastodon/blob/2889c686108e89a87317505f93b841f5a8a6649b/app/models/account.rb#L70)の関連付け（アソシエーション）を、全て[concerns/account_associations.rb](https://github.com/mastodon/mastodon/blob/2889c686108e89a87317505f93b841f5a8a6649b/app/models/concerns/account_associations.rb)に定義している。
  - 個人的な感想
    - moduleに定義することで可読性が下がる
    - rubocop対策で、ここではmoduleに定義しているのかな？

### Concernのアンチパターン
- ビジネスロジックをConcernに定義する → NG
  - model or 値オブジェクト or サービスオブジェクト を使用する
- rubocopのClassLength対策でConcernsにする → NG  
以下の書き方をすることで、解決できる
  ```ruby
  class Post < ApplicationRecord
    concerning :Previewable do
      # ...
    end
  
    concerning :Reservable do
      # ...
    end
  
    concerning :Bookmarkable do
      # ...
    end
  end
  ```

### その他
#### moduleを利用する際の注意点
- moduleでプライベートメソッドやインスタンス変数を定義する場合、他のmoduleやinclude先のクラスの定義と重複しないように気をつけて実装する必要がある。
  - 例：組み込みメソッドと同じ名前のメソッドをmoduleで実装した場合、そのメソッドはオーバーライドされてしまう。

##### 参考記事
- [我々はConcernsとどう向き合うか](https://blog.willnet.in/entry/2019/12/02/093000)
- [パーフェクトRuby on Rails](https://gihyo.jp/book/2020/978-4-297-11462-6)
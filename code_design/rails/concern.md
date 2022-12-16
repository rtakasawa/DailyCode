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

### ユースケース
- modelの場合
  - 抽出したいロジックが値オブジェクトやサービスオブジェクトで実装するべきではないか考える
- controllerの場合
  - 抽出したいロジックがモデルやフォームオブジェクトで実装するべきではないか考える
- 上記で実装すべきでないロジックの場合に、Concernを利用する
  - 例えば、
    - データ操作のロジック
    - 関連付けの宣言を行うレイヤー
- ルーティングにおいても共通の設定を再利用する仕組みがある。（`concern`メソッドを使う）


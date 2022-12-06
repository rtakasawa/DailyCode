# 既存テーブルにNOT NULL制約有のカラムを追加する場合のmigrationファイルの書き方（gem`paranoia`使用時）
## 開発環境
- Rails
- mysql
- gem`paranoia`
- AWS
  - ECS
  - RDS

## 状況1
- 本番環境にデプロイ
- 本番環境でマイグレーション実行

## 実行したマイグレーションファイル
```ruby
class AddColumnUsers < ActiveRecord::Migration[6.1]
  def up
    # Userテーブルにrollカラムを追加
    add_column :users, :roll, :integer
    # NOT NULL制約を設定するため、本番環境のUserレコードのrollカラムに値（1）を入れる
    User.update_all(roll: 1) 
    # rollカラムにNOT NULL制約を設定する
    change_column_null :users, :roll, false
  end

  def down
    remove_column :users, :roll
  end
end
```

## 状況2
- 上記マイグレーション実行時に`invalid use of NULL value`といったエラーが発生
- 本番環境のDBは以下の状態
  - rollカラムは追加されている
  - rollカラムにNOT NULL制約は設定されていない
  - 論理削除していないUserレコードのrollの値は1
  - 論理削除しているUserレコードのrollの値はnull

## 原因
- `User.update_all(roll: 1)`だと、論理削除したUserレコードが除かれているため、NOT NULL制約が設定できず、Errorになった

## 対応
- RDSの手動スナップショットを取得
  - DBの値を更新するので、念の為にスナップショットを取得した。
  - 以下記事と同様の対応をした。  
    [Amazon RDS(PostgreSQL)の手動スナップショットを取得する](https://www.capybara-engineer.com/entry/2022/01/21/143105)
- マイグレーションファイルを修正し、再度マイグレーションを実行

### 修正後のマイグレーションファイル
```ruby
class AddColumnUsers < ActiveRecord::Migration[6.1]
  def up
    # rollカラムがない場合に、カラムを追加するように修正（本番環境では既にrollカラムが存在するため）
    unless User.column_names.include?(:roll)
      add_column :users, :roll, :integer
    end
    
    # `with_deleted`を使うことで、論理削除したUserレコードも含まれる
    User.with_deleted.update_all(roll: 1)

    change_column_null :users, :roll, false
  end

  def down
    remove_column :users, :roll
  end
end
```

## 参考
- [中途半端なマイグレーション](https://qiita.com/jkr_2255/items/962861bf14f4749b992a)
- [NOT NULL制約追加時のinvalid use of NULL valueを解消する](https://www.tech-blog.startup-technology.com/2020/45eab0643a96ca9278d2/)

# Formオブジェクト

## Formオブジェクトとは
- モデル層に属するクラス群で、コントローラ層からユーザの入力を受けとり整形・検証し永続化する責務をもつ 
- また、ビュー層に表示するためのデータを提供する、という役割もある
- ActiveRecordモデルと1対1の場合があっても無くても良い
- 複数のActiveRecordモデルと関連する場合もあれば、対応するActiveRecordモデルがない場合にも採用できる

## 必要性
- フォームの責務をカプセル化し、コントローラやビューを疎結合に保つために必要なデザインパターン
- ユーザの入力の整形や永続化をコントローラだけで行うと、コントローラが肥大化する。  
この原因はコントローラがモデル層の知識をもちすぎるためにある。  
このときビューもフォームを表示するための知識をもつことになるため、コントローラと同じような問題が起こってしまう。  
このことは単一責任の原則に反し、モデル層の変更がコントローラやビューに影響を及ぼすことになる。
- 逆にActiveRecordモデルにこういった責務をもたせると、今度はActiveRecordモデルがフォームの知識を持ちすぎてしまう。 
フォームという独立した責務があるのであれば、これをひとつのクラスにカプセル化する、というのがFormオブジェクトの役割。
- Formオブジェクトにより、コントローラはFormオブジェクトの#saveのようなたったひとつのインタフェースのみを使うため、クラス間を疎結合に保てる。  
ビューもRailsのフレームワークに則った方法でフォームを表示できる。
- FormオブジェクトはActiveRecordモデルの#saveや#updateのような単純な命令以外のことをするフォームに有用。   
たとえば複数のActiveRecordモデルを操作したり、複数の子レコードをつくるといったものが該当する。   
また、フォームのふるまいに関するユニットテストが書きやすいというメリットもある。

## ユースケース
- ユーザの入力があり、ActiveRecordモデルの単純な#saveや#updateの命令で完結しない処理を行う場合に検討する。
- 次のようなケースに適用できる。 
  - サインアップ処理: ユーザの作成と他ユーザのフォローを同時に行うなど、複数のActiveRecordモデルを作成する 
  - 複数のタグを作成: 複数の子レコードを作成するとき。accepts_nested_attributes_forを使うような場面だけど使いたくないとき 
  - ブログの検索フォーム: Elasticsearchへのリクエストなど、ActiveRecordモデルを使用しない場合

## 使用例
- 題材：ブログの記事作成フォーム 
- 全体的な使い方を示せるよう、「作成・更新どちらにも対応」「検証」「複数の子要素を作成」をふまえる。
- 要件として、
  - 記事はタイトルと本文をもち、また複数のタグをもつ 
  - 制約としてタイトルが必須、またタグは1つ以上の入力を必要とする 
  - これを1つのトランザクション下で行う
- 説明しやすいよう、タグはカンマ区切りでひとつの入力欄に記述する形式をとっている

### テーブル設計
| Table | Column | Type | Not Null |
| --- | --- | --- | --- |
| posts | id | integer | ◯ |
|  | name | string | ◯ |
|  | content | text | - |
| tags | id | integer | ◯ |
|  | name | string | ◯ |
| taggings | post_id | integer | ◯ |
|  | tag_id | integer | ◯ |

### コントローラー
```ruby
# 記事の作成・編集を行うコントローラ
class PostsController < ApplicationController
  def new
    # フォームを扱うとき、一般的にはActiveRecordモデルのインスタンスをビューに渡すが、代わりにFormオブジェクトのインスタンスを渡している。
    @form = PostForm.new
  end

  def create
    # Formオブジェクトの初期化時に、#createと#updateのときはユーザの入力を渡している。
    @form = PostForm.new(post_params)

    if @form.save
      redirect_to posts_path, notice: 'The post has been created.'
    else
      render :new
    end
  end

  def edit
    load_post
    # 編集画面の#editと#updateには編集対象となる@postオブジェクトを渡している。
    @form = PostForm.new(post: @post)
  end

  def update
    load_post

    @form = PostForm.new(post_params, post: @post)

    if @form.save
      redirect_to @post, notice: 'The post has been updated.'
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :tag_names)
  end

  def load_post
    @post = current_user.posts.find(params[:id])
  end
end
```

### Formオブジェクト
- ユーザの入力とpostオブジェクトを受け取り、Post,Tag,Taggingの各モデルの作成・更新処理を行う。
- Formオブジェクトを使わないと、上記のロジックがコントローラやモデル、ビューに散らばる。
- Formオブジェクトにより、フォームのロジックをひとつのクラスにカプセル化できる。
```ruby
# app/forms/post_form.rb
class PostForm
  # 値の代入やバリデーション、コールバックなど、モデルのふるまいをするための、必要なモジュール
  include ActiveModel::Model

  # 値に書き込みメソッドだけでなく読み取りメソッドも定義しているのは、ビューのフォームに必要なため。 
  # たとえばform.text_field :titleはPostForm#titleから値を取得する。
  # フォームの内容に応じてメソッドを定義する必要がある。
  attr_accessor :title, :content, :tag_names

  validates :title, presence: true
  validates :split_tag_names, presence: true

  # ビューの表示（#form_with）に必要なメソッド。 
  # 作成・更新に応じてフォームのアクションをPOST・PATCHに切り替えてくれる。
  delegate :persisted?, to: :post

  def initialize(attributes = nil, post: Post.new)
    @post = post
    # 更新にも対応する場合は#default_attributesのように保存済みのレコードをもとに値を設定する必要がある。
    # 更新に対応しない場合は#initializeを定義する必要はない。 
    # この場合はActiveModel::Modelの#initializeにより自動で値の初期化を行ってくれる。
    attributes ||= default_attributes
    # superはActiveModel::Modelの#initializeを呼び出しており、
    # 書き込みメソッド（#title=など）を用いて値を代入している。 
    # つまり、Formオブジェクトで用いる値は書き込みメソッドを定義する必要がある。
    super(attributes)
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      tags = split_tag_names.map { |name| Tag.find_or_create_by!(name: name) }
      post.update!(title: title, content: content, tags: tags)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  # ビューの表示（#form_with）に必要なメソッド。
  # アクションのURLを適切な場所（ここではposts_pathやpost_path(id)）に切り替えてくれる。
  def to_model
    post
  end

  private
  
  attr_reader :post
  
  def default_attributes
    {
      title: post.title,
      content: post.content,
      tag_names: post.tags.pluck(:name).join(',')
    }
  end

  def split_tag_names
    tag_names.split(',')
  end
end
```

### ビュー
- `posts/new.html.erb`と`posts/edit.html.erb`から@formをformとして渡す想定
- Formオブジェクトに#persisted?と#to_modelを定義したことで、作成・更新画面に応じてフォームの内容を切り替えてくる
```erb
# posts/_form.html.erb
<%= form_with model: form, local: true do |form| %>
  <%= form.text_field :title %>
  <%= form.text_area :content %>
  <%= form.text_field :tag_names %>
  <%= form.submit %>
<% end %> 
```

## 設計ルール
- ActiveModel::Modelをincludeする 
- クラス名は接尾辞をFormにする（例：PostForm）
- `#save`や`#search`など、クラス名から推測可能な単一の処理用メソッドを定義する。失敗時にfalseを返す
- `#persisted?`と`#to_model`に反応するようにする 
- バリデーションを実装する。ただしActiveRecordモデルとの整合性に気をつける 
- Formオブジェクトがもつべき責務を明確にし、肥大化しないようにする。
たとえばレコード作成時にメールで通知するのはモデル層でなくコントローラ層で行う
- ユースケース毎にFormオブジェクトを実装する
  - 例：CSVインポートで複数のブログ投稿を同時に行う 等

## 引用
- [Railsのデザインパターン: Formオブジェクト](https://applis.io/posts/rails-design-pattern-form-objects)
- [パーフェクトRuby on Rails](https://gihyo.jp/book/2020/978-4-297-11462-6)
# 表示に関するロジック
## ビューヘルパー
### ビューヘルパーとは
- `app/helpers`に定義されたモジュールのインスタンスメソッド
- 慣例として、各モジュールでは、対応するコントローラーのビューで利用するヘルパーを実装する
  - 例：`UsersHelperモジュール`では、`UsersController`のビューで利用するヘルパーを実装する
### ビューヘルパーの課題
- 設定をしない限り、実装したモジュールは全てのコントローラーのビューで使用できる  
そのため、全てのビューヘルパーの名前が重複しないようにする必要がある。
- 設定をすると上記問題は解決するが、複数のコントローラー間で利用したいビューヘルパーを定義できなくなる。


## プレゼンター
- あるモデルが持つ属性やロジックを利用して、表示に関するロジックを実装するオブジェクト
- コントローラー単位ではなく、オブジェクト単位で表示に関するロジックを整理することで、ビューヘルパーの問題点を解決する。
- ビューヘルパーの呼び出しの多くは、ビューに渡したオブジェクトのメソッドの呼び出しに置き換えることができる
- モデルと1対1に対応するクラスやモジュールのインスタンスメソッドとして実装する
- ビューに渡していないメソッドはオブジェクトのメソッドは呼び出せないので、名前の重複を木にする必要がない
- 同じことをモデルのインスタンスメソッドとして実装することはできるが、モデルの肥大化を招くので、避けること
- 基本的にはviewの中でしか利用できない
## ActiveDecorator
- プレゼンターを利用できる仕組みがRailsにはないので、gemを使用するのが現実的
- ここではgem`ActiveDecorator`を使用する
### 利用の準備
- 対象のモジュール名が「#{対象のモデル名}Presenter」となるように以下設定を変更
- 設定を変更しない場合は、「#{対象のモデル名}Decorator」となる
```ruby
ActiveDecorator.configure do |config|
  config.decorator_suffix = "Presenter"
end
```
### 利用例
- emailの一部を伏せて表示したい
- 上記をpresenterに実装
```ruby
module UserPresenter
  # viewに渡したuserモデルのインスタンスをレシーバーとして呼び出せる
  def masked_email
    email.sub(/\A(?<init>.).+(?<tld>\.[^.]+)\z/, '\k<init>****@****\k<tld>')
  end
end
```
- presenterの利用
```ruby
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

end
```
```erb
<p id="notice"><%= notice %></p>

<p>
  <strong>Email:</strong>
  <%= @user.masked_email %>
</p>

<%= link_to 'Back', users_path %>
```

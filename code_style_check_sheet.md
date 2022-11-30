## 名前

- [ ]  明確な単語になっているか
- [ ]  汎用的な名前ではないか
- [ ]  名前に情報を追加できているか

   ```ruby
   # bad
   time = Time.now
   
   # good
   now_time = time = Time.now
   ```

- [ ]  名前の長さ
    - スコープが小さいときは短い名前でも良い
    - 不要な単語は捨てる

       ```ruby
       Convert_to_string ⇛ to_string
       ```

- [ ]  他の意味と間違えられないか
- [ ]  限界値を含めるときはmaxとminを使う

   ```ruby
   # 仕様：カートには10点までしか入らない
   
   # BAD
   # 10未満？10以下？が分からない
   CART_TO_BIG_LIMIT = 10
   
   # GOOD
   MAX_ITEMS_IN_CART = 10
   ```

- [ ]  範囲を指定するときはfirstとlastを使う

   ```ruby
   # 仕様：1〜5の数字を出力する
   
   # bad
   # stopは複数の5未満？5以上？
   puts range(start:1, stop:5)
   
   # good
   # 包含を表現する場合、lastが適切
   puts range(first:1, last:5)
   ```

- [ ]  包含/排他的範囲にはbeginとendを使う
- [ ]  ブール値の名前

   ```ruby
   # bad
   # 数値を返す用に聞こえる
   ded SpaceLeft
       ***
   end
   
   # good
   # bool値の変数名は頭にhas,can,shouldをつけると分かりやすい
   def had_space_left
       ***
   end
   ```

   ```ruby
   # bad
   # 名前の否定形は読みづらい
   disable_ssl = false
   
   # good
   use_ssl = true
   ```

- [ ]  誤解されない名前を使っていないか
    - 以下の名前は軽量な処理が期待される
        - get
        - size

### Ruby/Ruby on Rails
- model
  - [ ] 品詞にする 
  - [ ] 2つの単語をつなげてモデルを作る場合は、形容詞+名詞 or 名詞 + 名詞 
- method
  - [ ] 処理を実行するメソッドは、動詞のみ or 動詞 + 名詞
  - [ ] 注意：動詞で始めるのは、あくまで「処理を実行するメソッド」が対象
    ```ruby
    # 「処理を実行するメソッド」ではないメソッド例
         
    # 名と姓を返す
    def full_name
    end
         
    # メール受信者が何かアクションを起こす必要があればtrue
    mail.action_required?
         
    # 文字列をDate型に変換する
    to_date('2021-1-1')
         
    class Member < ApplicationRecord
     # チームメンバーが規定の人数を超えていないことを検証する
     validate :member_count_should_not_exceed, on: :create
    end
    ```
  - [ ] 状態を表したい場合は、名詞+動詞の過去分詞形
    ```ruby
    # bad
    gate.need_password
        
    # good
    gate.password_required
    ```
  - 論理値（trueかfalseのいずれか）のみを返すメソッド
    - [ ] 末尾に疑問符を置く
    - [ ] 冒頭にisやdoesやcanといった助動詞はなるべく置かないようにする
- その他
  - [ ] 不可算名詞（複数形の無い名詞）の使用は極力避ける
- 引用元
  - [モデルやメソッドに名前を付けるときは英語の品詞に気をつけよう](https://qiita.com/jnchito/items/459d58ba652bf4763820)
  - [Rubyスタイルガイドを読む: 命名](https://techracho.bpsinc.jp/hachi8833/2017_02_13/35364#3)

## スタイル

- [ ]  改行位置は揃っているか
- [ ]  共通部分はメソッド化する
- [ ]  縦の線を真っ直ぐにする
- [ ]  一貫性と意味のある並びにする

   ```ruby
   # bad
   details  = request.POST.get('details')
   location = request.POST.get('location')
   url      = request.POST.get('url')
   
   ## 順番が変わっていて分かりづらい
   return ** if rec.location == location
   return ** if rec.url      == url
   return ** if rec.details  == details
   
   # good
   details  = request.POST.get('details')
   location = request.POST.get('location')
   url      = request.POST.get('url')
   
   return ** if rec.details  == details
   return ** if rec.location == location
   return ** if rec.url      == url
   ```

- [ ]  空行、コメントを使って、論理的な「段落」に分ける

   ```ruby
   # bad
   def create_document(json)
       values = fetch_values(json)
       sub_values = fetch_sub_values(json)
       processed_values = processing_values(values)
       processed_sub_values = processing_values(sub_values)
       output_values(values, sub_values)
   end
   
   # good
   def create_document(json)
       # json内から該当の値を取得
       values = fetch_values(json)
       sub_values = fetch_sub_values(json)
       
       # 値を加工
       processed_values = processing_values(values)
       processed_sub_values = processing_values(sub_values)
   
       # 値を出力
       output_values(values, sub_values)
   end
   ```

- [ ]  一貫性のあるスタイルにする
    - プロジェクトの規約に従う

   ```ruby
   # example1
   hash = {
   }
   
   # example2
   hash = 
   {
   }
   ```

### Ruby/Ruby on Rails
- クラス定義
  - [ ]  定義の順番
     ```ruby
     class Person
       # extendとincludeは他の要素より先に書く
       extend SomeModule
       include AnotherModule
         
       # インナークラス定義は最初に書く
       CustomError = Class.new(StandardError)
         
       # 定数はその次に書く
       SOME_CONSTANT = 20
         
       # 属性マクロはその次に書く
       attr_reader :name
         
       # その他のマクロがあればここに書く
       validates :name
           
       # publicなクラスメソッドはその次にインライン形式で書く（class << selfでもよい: 後述）
       def self.some_method
       end
         
       # 初期化メソッドはクラスメソッドと他のインスタンスメソッドの間に書く
       def initialize
       end
         
       # publicなインスタンスメソッドはその後に書く
       def some_method
       end
           
       # protectedメソッドやprivateメソッドは末尾にまとめる
       protected
           
       def some_protected_method
       end
           
       private
           
       def some_private_method
       end
     end
     ```
  - [ ]  mixinが複数ある場合は別々に書く
     ```ruby
     # bad
     class Person
      include Foo, Bar # 複数のmixinが1行で書かれている
     end
         
     # good
     class Person
       include Foo      # mixinは1行ずつ分けて書く
       include Bar
     end
     ```
  - [ ]  1つのファイル内に複数行の大きなクラスを複数定義しない
     ```ruby
     # bad
         
     # foo.rb
     class Foo
       class Bar
       # メソッドが30ほどある
       end
            
       class Car
       # メソッドが20ほどある
       end
            
       #   メソッドが30ほどある
     end
          
          
     # good
          
     # foo.rb
     class Foo
       #   メソッドが30ほどある
     end
          
     # foo/bar.rb
     class Foo
       class Bar
        # メソッドが30ほどある
       end
     end
          
     # foo/car.rb
     class Foo
       class Car
        # メソッドが20ほどある
       end
     end
     ```
  - [ ]  クラスメソッドしか持たないクラスは、モジュールに書き換えるのが望ましい
  - 引用元
     - [【保存版】Rubyスタイルガイド（日本語・解説付き）総もくじ](https://techracho.bpsinc.jp/hachi8833/2017_05_15/38869)

## コメント

- [ ]  コメントの品質を上げる方法
    1. 頭の中にあるコメントをそのまま書く
    2. 1を読んで、改善が必要な箇所を見つける
    3. 改善する
- [ ]  自分の考えを記録する

   ```ruby
   # このクラスは汚くなってきている
   # サブクラスを作って整理した方が良いかもしれない
   ```

   ```ruby
   # この場合〇〇が漏れるケースがある。しかし、100%の対応は難しい。
   ```

- [ ]  アノテーションを使う

   ```ruby
   TODO:  # 後で手を付ける
   FIXME: # 既知の不具合あり
   HACK:  # あまりきれいじゃない解決策
   XXX:   # 危険!　大きな問題あり 
   ```

- [ ]  定数にコメントを付ける
    - なぜその値を持っているのかという「背景」をコメントにする

   ```ruby
   # 合理的な限界値。人間はこんなに読めない。
   MAX_RSS_SUBSCRIPTIONS = 1000
   ```

- [ ]  ハマりそうな罠を告知する

   ```java
   // good
   // 以下のコメントがないと、処理の中でSendEmailを呼び出して、タイム・アウトした場合に、処理全体が異常終了する可能性がある
   
   // メールを送信する外部サービスを呼び出している（1分でタイムアウト）
   void SendEmail(string to, string subject, string body);
   ```

- [ ]  classやfileに全体像のコメントをする

   ```ruby
   # このmoduleはfile出力に関する便利なヘルパーメソッドを定義してます。
   module OutputFile
   end
   ```

- [ ]  曖昧な代名詞を使わない（「その」等）
- [ ]  メソッドの動作を正確にコメントする

   ```ruby
   # bad
   # このファイルに含まれる行数を返す。
   def count_lines(file)
   end
   
   # good
   # このファイルに含まれる改行文字（\ｎ）の数を返す。
   def count_lines(file)
   end
   ```

- [ ]  実例を使う

   ```ruby
   # bad
   # srcの先頭や末尾にあるcharsを除去する。
   def strip(src, chars)
   end
   
   # good
   # srcの先頭や末尾にあるcharsを除去する。
   # 例：strip('ab', 'a')の場合、aを返す
   def strip(src, chars)
   end
   ```

- [ ]  情報密度の高いコメントを使う

   ```ruby
   # before
   # 所在地から余分な空白を除去。さらに「Avenue」を「Ave」にする等の整形をする。
   
   # after
   # 所在地を正規化する（例：「Avenue」を「Ave」にする）
   ```


## 制御フローを読みやすくする

- [ ]  条件式の引数の並び順

   ```ruby
   # 左側：調査対象の式（変化する）
   # 右側：比較対象の式（あまり変化しない）
   
   # bad
   if 10<= length
   
   # good
   if length >= 10
   ```

- [ ]  if/elseブロックの並び順
    - 条件は肯定形を使う

        ```ruby
        # bad
        if a != b
        else
        end
        
        # good
        if a == b
        else
        end
        ```

    - 単純な条件を先に書く
    - 関心を引く条件、目立つ条件を先に書く

        ```ruby
        if not_file
        	# Errorログを記録す
        else
        end
        ```

- [ ]  三項演算子
    - 基本的にはif/elseを使う

        ```ruby
        #bad
        exponent >= 0 ? mantissa * (1 << exponent) : mantissa / (1 << - exponent)
        
        #good
        if exponent >= 0
        	mantissa * (1 << exponent)
        else
        	mantissa / (1 << exponent)
        end
        ```

    - 簡潔になるときだけ、三項演算子を使う

        ```ruby
        #bad
        if hour >= 12
        	time_str += "pm"
        else
        	time_str += "am"
        end
        
        #good
        time_str += hour >= 12 ? "pm" : "am"
        ```

- [ ]  関数から早く返す

   ```ruby
   # ガード節を使う
   return '' if hour.blank?
   ```

- [ ]  ネストを浅くする
    - 早めに返してネストを削除する

        ```ruby
        if user_result != SUCCESS
        	reply.WriteErrors(user_result)
        	reply
        	return
        end
        
        if permission_result != SUCCESS
        	reply.WriteErrors('error reading permissions')
        	reply
          return
        end
        
        reply.WriteErrors('')
        reply
        ```

    - `next`を使ってループ内のネストを削除する

        ```java
        // bad
        for (int i = 0; i < results.size(); i++) {
        	if (results[i] != NULL) {
        		non_null_count++;
        
        		if (results[i]->name != "") {
        				coun << "Considering candidate ...." << end1;
        		}
        	}
        }
        
        // good
        // if・・・continueを使って処理をskipする
        // rubyだとnext if文となる
        for (int i = 0; i < results.size(); i++) {
        	if (results[i] == NULL) continue;
        	non_null_count++;
        
        	if (results[i]->name == "") continue;
        	coun << "Considering candidate ...." << end1;
        }
        ```


## 式を分割する

- [ ]  説明変数を使う

   ```ruby
   # bad
   if line.split(':')[0].strip == "root"
   
   # good
   # 比較対象が分かりやすくなった
   user_name = line.split(':')[0].strip
   if user_name == "root"
   ```

- [ ]  要約変数を使う

   ```ruby
   # bad
   if request.user.id == document.owner.id
   end
   
   if request.user.id != document.owner.id
   end
   
   # good
   # 変数を個別に読む必要がなくなった
   user_owns_document = request.user.id == document.owner_id
   
   if user_owns_document
   end
   
   if !user_owns_document
   end
   ```

- [ ]  ド・モルガンの法則を使う

   ```markdown
   - notを分配してand/orを反転する
   not (a or b or c) ⇔　(not a) and (not b) and (not c)
   not (a and b and c) ⇔　(not a) and (not b) and (not c)
   ```

   ```ruby
   # bad
   if (!(file_exists && !is_protected))
   end
   
   # good
   if (!file_exists || is_protected)
   end
   ```

- [ ]  読みづらい短絡評価を使用していないか

   ```java
   // bad
   assert((!(bucket = FindBucket(key))) || !bucket->IsOccupied());
   
   // good
   // 2行になったけど読みやすくなった!
   bucket = FindBucket(key);
   if (bucket != NULL) assert(!bucket->IsOccupied());
   ```

- [ ]  ロジックを反対にすることで簡単に解決できる場合もある

   ```java
   //仕様：beginまたはendがotherの中にあるか確認する
   
   // bad
   (begin >= other.begin && begin < other.end) ||
   (end > other.begin && end <= other.end) ||
   (begin <= other.begin && end >= other.end);
   
   //good
   if (other.end <= begin) return false; // 一方の終点が、この終点より前にある
   if (other.begin >= end) return false; // 一方の始点が、この終点より後にある
   ```


## 変数

- [ ]  変数に代入するのは初めの1度だけにする（なるべく）
    - または定数を使って、変更がないようにする
    - 変数が変わる場所が増えると、現在値の判断が大変
- [ ]  変数のスコープはできるだけ小さくする
- [ ]  邪魔な変数は削除する
    - 邪魔な変数
        - 一時変数

            ```java
            # bad
            # now:複雑な式を分解していない
            # now:datetime.datetime.now()のままでも意味が通じる
            # now:1度しか使っていないので、重複削除になっていない
            now = datetime.datetime.now()
            root_message.last_view_time = now
            
            # good
            root_message.last_view_time = datetime.datetime.now()
            ```

        - 中間結果の変数

            ```jsx
            # bad
            # index_to_remove:中間結果を保持するためだけに使っているので、削除できる。
            var remove_one = function (array, value_to_remove) {
            	var index_to_remove = null;
            	for (var i = 0; i < arrary.length; i += 1) {
            		if (array[i] === value_to_remove) {
            			index_to_remove = i;
            			break;
            		}
            	}
            	if (index_to_remove != null) {
            		array.splice(index_to_remove, 1);
            	}
            };
            
            # good
            var remove_one = function (array, value_to_remove) {
            	for (var i = 0; i < array.length; i += 1) {
            		if(array[i] === value_to_remove) {
            			array.splice(i, 1);
            			return;
            		}
            	}
            };
            ```

        - 制御フロー変数

            ```java
            # bad
            # doneはプログラミングを制御するための変数
            # 実際のプログラミングに関係のあるデータは保持していない
            # 制御フロー変数という
            boolean done = false;
            while (/* 条件 */ && !done) {
            	・・・
            	if(・・・) {
            			done = true;
            			continue;
            	}
            }
            
            # good
            # 制御フロー変数は削除できる
            boolean done = false;
            while (/* 条件 */) {
            	・・・
            	if(・・・) {
            		break;
            	}
            }
            ```


## メソッド・コードブロック

- [ ]  無関係の下位問題を抽出して、別のメソッドに処理を移動する
    1. メソッドやコードブロックを見て、「このコードの高レベル目標は何か？」を自問する。
    2. コードの各行にたいして、「高レベル目標に直接効果があるのか？あるいは、無関係の下位問題を解決しているのか？」と自問する。
    3. 無関係の下位問題を解決しているコードが相当量あれば、それらを抽出して別の関数にする。
- [ ]  1度に複数のタスクを行っていないか

  「1度に1つのタスク」となるように関数を使って処理を分割する

- [ ]  コードをより簡単にする手順
    1. コードの動作を簡単な言葉を使って同僚に説明する

       （コードを声に出して説明する）

    2. 説明の中で使っているキーワードやフレーズに注目する
    3. 説明に合わせてコードを書く

   ```php
   // before
   $is_admin = is_admin_request();
   if ($document) {
       if (!is_admin && ($document['username'] != $_SESSION['username'])) {
           return not_authorized();
       }
   } else {
           if (!$is_admin) {
               return not_authorized();
       }
   }
   
   // 【このロジックの説明】
   // 権限があるのは以下2つ
   // ・管理者
   // ・文書の所有者（文書がある場合）
   // その他は権限なし
   
   // after（ロジックの説明を踏まえて）
   // ロジックが単純になった（否定形（!）がなくなった）
   if (is_admin_request()) {
       //権限あり
   } elseif ($document['username'] != $_SESSION['username'])) {
       //権限あり
   } else {
       return not_authorized();
   }
   ```

- [ ]  メソッドの分割しすぎには注意

   ```python
   # bad
   # 小さい関数を作りすぎると読みにくくなる（あちこちに飛び回るため）
   # 他の部分で再利用する必要があった場合に、小さい関数を追加する。
   
   user_info = { "username": "...", "passeord": "..." }
   url = "http://example.com/?user_info=" + url_safe_encrypt(user_info)
   
   def url_safe_encrypt_obj(obj):
       obj_str = json.dump(obj)
       return url_safe_encrypt_str(obj_str)
   
   def url_safe_encrypt_str(data):
       encrypted_bytes = encrypt(data)
       return base64.urlsafe_b64encode(encrypted_bytes)
   
   def encrypt(data):
       cipher = make_cipher()
       encrypted_bytes = cipher.update(data)
       encrypted_bytes += cipher.final()
       return encrypted_bytes
   
   def make_cipher():
       return Cipher("aes_128_cbc", key=PRIVATE_KEY, init_vector=INIT_VECTOR, op=ENCODE)
   
   ```
### Ruby/Ruby on Rails
- [ ]  アクセサ（読み取り用）やミューテタ（書き込み用）には属性名をそのまま使う
```ruby
# bad
class Person
  def get_name
    "#{@first_name} #{@last_name}"
  end
  
  def set_name(name)
    @first_name, @last_name = name.split(' ')
  end
end

# good
class Person
  def name
    "#{@first_name} #{@last_name}"
  end
  
  # ミューテターには属性名=を使う
  def name=(name)
    @first_name, @last_name = name.split(' ')
  end
end
```
- 引用元
    - [【保存版】Rubyスタイルガイド（日本語・解説付き）総もくじ](https://techracho.bpsinc.jp/hachi8833/2017_05_15/38869)

## その他
### 短いコードを書く
- [ ]  不必要な機能は削除する。過剰な機能は不要。
- [ ]  問題（POからの要望）を最も簡単に解決できる対応を考える。
- [ ]  定期的に全てのAPIを読んで、標準ライブラリを使えるようにする。

### Hash/Array
#### Ruby/Ruby on Rails
- [ ]  ハッシュのキーの存在を前提にする場合はHash#fetchを使うこと
```ruby
heroes = { batman: 'Bruce Wayne', superman: 'Clark Kent' }
# bad キーが無効でもエラーにならない
heroes[:batman] # => 'Bruce Wayne'
heroes[:supermann] # => nil

# good KeyErrorでキーがないことを検出できる
heroes.fetch(:supermann)
```

- [ ]  ハッシュ値のデフォルト値が欲しい場合はHash#fetchでデフォルト値を与えること
```ruby
batman = { name: 'Bruce Wayne', is_evil: false }

# bad
# ||演算子ではハッシュの値がfalseと同値の場合に正しく処理されない
batman[:is_evil] || true # => true

# good
# ハッシュの値がfalseと同値であっても正常に処理できる
batman.fetch(:is_evil, true) # => false
```

- [ ]  Hash#fetchでデフォルト値を与える場合に、デフォルト値が重い処理の場合の対応
```ruby
batman = { name: 'Bruce Wayne' }

# bad 
# `Hash#fetch`のデフォルト値にコードを設定すると毎回評価されてしまう
# このため繰り返しが多いと速度が低下する
batman.fetch(:powers, obtain_batman_powers) # obtain_batman_powersでは重たい処理を行うとする

# good
# ブロックで与えたコードは遅延評価されるので、KeyError発生時以外は評価されない
batman.fetch(:powers) { obtain_batman_powers }
```

- [ ]  コレクションにはできるだけ[n]以外の読み出しメソッドでアクセスすること
```ruby
str = "This is Regexp"
/That is Regexp/ =~ str
p Regexp.last_match # => nil

begin
  p Regexp.last_match[1] # 例外が発生する
rescue
  puts $! # => undefined method `[]' for nil:NilClass
end

p Regexp.last_match(1) # => nil（例外ではない！！）
```

- [ ]  コレクションにアクセサを実装する場合はnilチェックすること
```ruby
# bad
def awesome_things
  @awesome_things
end

# good
# コレクションにnilでアクセスしないよう、メソッド側で対応
def awesome_things(index = nil)
  if index && @awesome_things
    @awesome_things[index]
  else
    @awesome_things
  end
end
```

### クラス設計
#### Ruby/Ruby on Rails
- [ ]  使い捨てのクラス定義には'Struct.new'を使う
```ruby
class Person
  attr_accessor :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
end

# 上記は以下で書ける
Person = Struct.new(:first_name, :last_name) do
end
```
- [ ]  'Struct.new'を継承しない。ループの中で使わない。
```ruby
# bad
class Person < Struct.new(:first_name, :last_name)
end
```
- [ ]  特別な前処理が必要なクラスはファクトリメソッドの追加を検討する。
```ruby
class Person
  # ファクトリメソッド
  def self.create(options_hash)
    # 特別な前処理
  end
end
```

### 例外
#### Ruby/Ruby on Rails
- [ ] raiseの引数には、例外クラスとメッセージの2つの引数を与えるのが望ましい
```ruby
# good
# 例外クラスとメッセージを渡すことで、'backtrace'が利用できる
raise SomeException, 'message'
```

- [ ]  例外処理の共通化
```ruby
# bad
begin
  something_that_might_fail
rescue
  # IOErrorの処理
end

begin
  something_else_that_might_fail
rescue
  # IOErrorの処理
end

# good
def with_error_handling
  yield
rescue IOError
  # IOErrorの処理
end

# 実行コード
# - IOError処理を検証したいメソッドを、with_error_handlingに{}で渡せば、検証できる（共通化）
with_error_handling { something_that_might_fail }
```

- [ ]  プログラムで取得した外部リソースは、必ずensureブロックで解放する。または、自動でクリーンアップするタイプのものを使う。
```ruby
f = File.open('test')
begin
rescue
ensure
  f.close if f
end
```


## 引用文献
- リーダブルコード
- [【保存版】Rubyスタイルガイド（日本語・解説付き）総もくじ](https://techracho.bpsinc.jp/hachi8833/2017_05_15/38869)
- [モデルやメソッドに名前を付けるときは英語の品詞に気をつけよう](https://qiita.com/jnchito/items/459d58ba652bf4763820)
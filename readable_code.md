# リーダブルコード_チェックリスト
## 名前
- [ ] 明確な単語になっているか
- [ ] 汎用的な名前ではないか
- [ ] 名前に情報を追加できているか
    ```ruby
    # bad 
    time = Time.now
    
    # good
    now_time = time = Time.now
    ```
- 名前の長さ
  - [ ] スコープが小さいときは短い名前でも良い
  - [ ] 不要な単語は捨てる
    ```ruby
    Convert_to_string ⇛ to_string
    ```
- [ ]  他の意味と間違えられないか
- [ ]  限界値を含めるときはmaxとminを使う
   ```ruby
   # 仕様：カートには10点までしか入らない
   
   # bad
   # 10未満？10以下？が分からない
   CART_TO_BIG_LIMIT = 10
   
   # good
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
   # readは複数の解釈を持つため
   read_password = true
   
   # good
   need_password = true
   user_is_authenticated = true
   ```
   ```ruby
   # bad
   # 数値を返す用に聞こえる
   def SpaceLeft
      '***'
   end
   
   # good
   # bool値の変数名は頭にhas,can,shouldをつけると分かりやすい
   def had_space_left
      '***'
   end
   ```
   ```ruby
   # bad
   # 名前の否定形は読みづらい
   disable_ssl = false
   
   # good
   use_ssl = true
   ```

- [ ]  誤解されない名前を使う
    - 以下の名前は軽量な処理が期待される
        - get
        - size

## 美しさ
- [ ]  改行位置は揃っているか

   ```java
   /* bad */
   public class PerformanceTester
       public static final TcpConnectionSimulator wifi = new TcpConnectionSimulator(
           500, /* 接続速度 */
           80, /* 平均遅延時間 */
           200, /* 遅延イライラ時間 */
           1); /* パケットロス時間 */
   
       public static final TcpConnectionSimulator t3_fiber = 
           new TcpConnectionSimulator(
               4500, /* 接続速度 */
               10, /* 平均遅延時間 */
               0, /* 遅延イライラ時間 */
               0); /* パケットロス時間 */
   }
   
   /* good */
   /* 改行位置を揃える */
   /* 重複したコメントを一つにする */
   public class PerformanceTester
       // TcpConnectionSimulator(接続速度, 平均遅延時間, 遅延イライラ時間, パケットロス時間)
   
       public static final TcpConnectionSimulator wifi = 
           new TcpConnectionSimulator(
               500,
               80,
               200,
               1);
   
       public static final TcpConnectionSimulator t3_fiber = 
           new TcpConnectionSimulator(
               4500,
               10,
               0,
               0);
   }
   ```

- [ ]  共通部分はメソッド化する

   ```java
   // bad
   // 改行位置を整えたいが、複数出現するdatabase_connectionやerrorが邪魔をしている
   DatabaseConnection database_connection;
   string error;
   assert(ExpandFullName(database_connection, "Doug Adams", &error)
       == "Mr. Douglas Adams");
   assert errror;
   assert(ExpandFullName(database_connection, "No Such Guy", &error) == "");
   assert(errror == "no match found");
   
   // good
   // 共通部分をメソッド化する
   // ⇛・コードが簡潔になった
   //  ・テストケースの大切な部分が見やすくなった
   //  ・テストの追加が簡単になった
   CheckFullName("Doug Adams", "Mr. Douglas Adams", '');
   CheckFullName("NO Such Guy", "", "no match found");
   ```

- [ ]  縦の線を真っ直ぐにする

   ```ruby
   # bad
   numbers = [
       [1,2,3],
       [10,20,30],
       [100,200,300],
   ]	
   
   # good
   numbers = [
       [1,   2,   3],
       [10,  20,  30],
       [100, 200, 300],
   ]	
   ```

- [ ]  一貫性と意味のある並び

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

- [ ]  一貫性のあるスタイル
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

## コメントすべきことを知る
- [ ]  コメントするべきでは「ない」こと
    
    ```ruby
    # good
    # コードを読むより、コメントを見たほうが理解できる
    
    # 2番目の'*'以降を全て削除する
    name = '*'.join(line.split('*')[:2])
    ```
    
    ```java
    // bad
    // 関数宣言と同じコメント
    
    // 与えられたsubtreeに含まれるnameとdepthに合致したNodeを見つける。
    Node* FindNodeInSubtree(Node* subtree, string name, int depth);
    
    // good
    
    // 与えられたnameに合致したNodeかNullを返す。
    // depth <= 0 の場合、subtreeだけ調べる
    // depth == N の場合、subtreeとその下のN階層まで調べる
    Node* FindNodeInSubtree(Node* subtree, string name, int depth);
    ```
    
- [ ]  自分の考えを記録する
    
    ```ruby
    # このクラスは汚くなってきている
    # サブクラスを作って整理した方が良いかもしれない
    ```
    
    ```ruby
    # この場合〇〇が漏れるケースがある。しかし、100%の対応は難しい。
    ```
    
- [ ]  コードの結果にコメントをつける
    - よく使う記法
        
        ```ruby
        # 後で手を付ける
        TODO: 
        
        # 既知の不具合あり
        FIXME: 
        
        # あまりきれいじゃない解決策
        HACK: 
        
        # 危険!　大きな問題あり
        XXX: 
        ```
        
- [ ]  定数にコメントを付ける
    - なぜその値を持っているのかという「背景」をコメントにする
    
    ```ruby
    # 合理的な限界値。人間はこんなに読めない。
    MAX_RSS_SUBSCRIPTIONS = 1000
    ```
    
- [ ]  嵌りそうな罠を告知する
    
    ```java
    // good
    // 以下のコメントがないと、処理の中でSendEmailを呼び出して、タイム・アウトした場合に、処理全体が異常終了する可能性がある
    
    // メールを送信する外部サービスを呼び出している（1分でタイムアウト）
    void SendEmail(string to, string subject, string body);
    ```
    
- [ ]  全体像のコメント
    
    ```ruby
    # このmoduleはfile出力に関する便利なヘルパーメソッドを定義してます。
    module OutputFile
    end
    ```
    
- [ ]  コメントの品質を上げる方法
    1. 頭の中にあるコメントをそのまま書く
    2. 1を読んで、改善が必要な箇所を見つける
    3. 改善する

## コメントは正確に簡潔に
- [ ]  曖昧な代名詞を使っていないか
    
    ```ruby
    # bad
    # データをキャッシュに入れる。ただし、先にそのサイズをチェックする。
    
    # good
    # データをキャッシュに入れる。ただし、先にデータのサイズをチェックする。
    # データが十分小さければ、そのデータをキャッシュに入れる。
    ```
    
- [ ]  メソッドの動作を正確にコメントしているか
    
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
    
- [ ]  情報密度の高いコメントを使えているか

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
    - 並び順の優劣
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
    - ガード節を使う
- [ ]  ネストを浅くする
    - ネストが増える仕組み
        
        ```ruby
        # first code
        if user == SUCCESS
        	reply.WriteErrors('')
        else
        	reply.WriteErrors(user_result)
        end
        
        reply
        
        # second code
        # 条件を追加 →　ネストが深くなった。分かりづらくなった。
        if user == SUCCESS
        	if permission_result != SUCCESS
        		reply.WriteErrors('error reading permissions')
        		reply
            return
        	end
        	reply.WriteErrors('')
        else
        	reply.WriteErrors(user_result)
        end
        ```
        
    - [ ]  早めに返してネストを削除する
        
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
        
    - [ ]  ループ内のネストを削除する
        
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
        

## 巨大な式を分割する
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
      
- [ ]  短絡評価の悪用
    
   ```java
   # bad
   assert((!(bucket = FindBucket(key))) || !bucket->IsOccupied());
      
   # good
   # 2行になったけど読みやすくなった!
   bucket = FindBucket(key);
   if (bucket != NULL) assert(!bucket->IsOccupied());
   ```

- [ ] 複雑なロジックと格闘する
    - [ ] より優雅な手法を考える
        - 「反対」から解決する
            - 例
                - 配列を逆順にイテレーターとする
                - データを後ろから挿入する
            
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

## 変数と読みやすさ
- まとめ（先に）
    - [ ]  一度だけ書き込む変数を使う（定数ももちろん良い）
    - [ ]  邪魔な変数は削除する
        - 中間結果の変数
        - 一時変数
        - 制御フロー変数
    - [ ]  変数のスコープはできるだけ小さくする
- 詳細
    - [ ]  不要な変数を削除する
        - 不要な変数
            - コードが読みやすくならない変数
            - 不要な変数 ≠ 説明変数
            - 不要な変数 ≠ 要約変数
        - [ ]  役に立たない一時変数

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

        - [ ]  中間結果を削除する

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

        - [ ]  制御フロー変数を削除する

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

            - breakが使えないようなネストが何段階もあるループの場合
                - コードを新しいメソッドに移動する
                    - ループ内部のコード
                    - ループ全体
        - [ ]  変数のスコープを縮める
            - [ ]  変数のことが見えるコード行数をできるだけ減らす
                - 考えなければいけない変数の量を減らせるから

               ```java
               // bad
               class LangeClass {
                   // インスタンス変数は2箇所で使用している
                   string str_;
               
                   void Method1() {
                       str_ = ・・・;
                       Methodd2();
                   }
               
                   void Method2() {
                       // str_を使っている
                   }
               
                   // str_を使っていないメソッドがたくさんある
               };
               
               // good
               class LangeClass {
                   void Method1() {
                       // インスタンス変数をローカル変数に格下げした
                       // 格下げしたことで、インスタンス変数の値の状況を追跡する必要がない
                       string str_ = ・・・;
                       Methodd2();
                   }
               
                   void Method2(string str) {
                       // str_を使っている
                   }
               
                   // その他のメソッドがstrが見えない
               };
               ```

            - [ ]  if文のscope

               ```cpp
               // bad
               PaymentInfo* info = database.ReadPaymentInfo();
               if (info) {
                   cout << "User paid: " << info ->amount() << end1;
               }
               
               // good
               // infoが必要なのはif文の中だけなので、条件式でinfoを定義している
               if (PaymentInfo* info = database.ReadPaymentInfo()) {
                   cout << "User paid: " << info ->amount() << end1;
               }
               ```

            - [ ]  グローバル変数をクロージャーで包む（Javascript）
                - クロージャとは  
               関数とその関数が定義された状態をセットにした特殊なオブジェクト

                ```jsx
                // bad
                submitted = false; // グローバル変数
                
                var submit_form = function (form_name) {
                	if (submitted) {
                			return; // 二重投稿禁止
                	}
                	...
                	submitted = true;
                };
                
                // good
                var submit_form = (function () {
                	submitted = false; // 以下の関数からしかアクセスできない
                
                	return function (form_name) {
                		if (submitted) {
                			return; // 二重投稿禁止
                		}
                		...
                		submitted = true;
                	};
                }());
                ```
                
            - [ ]  JavaScriptのグローバルスコープ
                
                ```jsx
                // bad
                <script>
                	var f = function () {
                		// 危険:'i'は'var'で宣言されていないので、グローバルスコープになる!!
                		// どこからでも参照できてしまう。
                		for (i = 0; i < 10; i += 1)...
                	};
                	
                	f();
                </script>
                
                // bad example
                <script>
                	alert(i); // 10が表示される
                </script>
                
                // good
                <script>
                	var f = function () {
                		// 危険:'i'は'var'で宣言されていない!
                		for (var i = 0; i < 10; i += 1)...
                	};
                	
                	f();
                </script>
                ```
                
            - [ ]  変数は変数の使う直前に定義する
        - [ ]  変数に代入するのは初めの1度だけにする（または定数を使って、変更がないようにする）
            - 変数が変わる場所が増えると、現在地の判断が大変
                
                ```jsx
                // bad
                var setFirstEmptyInput = function (new_value) {
                	var found = false;
                	var i = 1;
                	var elem = document.getElementById('input' + 1);
                	while (elem !== null) {
                		if (elem.value === '') {
                			found = true;
                			break;
                		}
                		i++;
                		elem = document.getElementById('input' + i);
                	}
                	if (found) elem.value = new.value;
                	return elem;
                };
                
                // good
                // 中間変数のfoundを除去した
                var setFirstEmptyInput = function (new_value) {
                	var i = 1;
                	var elem = document.getElementById('input' + 1);
                	while (elem !== null) {
                		if (elem.value === '') {
                			elem.value = new.value;
                			return elem;
                		}
                		i++;
                		elem = document.getElementById('input' + i);
                	}
                	return null;
                };
                
                // more_good
                // 変数elemはiに合わせて繰り返し処理（イテレート）していた
                // そのためfor文に変えてみる → これで変数iの定義が1行で書けるようになった
                var setFirstEmptyInput = function (new_value) {
                	for (var i = 1; true; i++) {
                		var elem = document.getElementById('input' + i);
                		if (elem === null)
                			return null;
                		
                		if (elem.value === '')
                			elem.value = new.value;
                			return elem;
                		}
                	}
                };			
                ```

- 無関係の下位問題を抽出する
    - [ ]  無関係の下位問題を抽出して、別のメソッドに処理を移動する
        1. メソッドやコードブロックを見て、「このコードの高レベル目標は何か？」を自問する。
        2. コードの各行にたいして、「高レベル目標に直接効果があるのか？あるいは、無関係の下位問題を解決しているのか？」と自問する。
        3. 無関係の下位問題を解決しているコードが相当量あれば、それらを抽出して別の関数にする。

       ```jsx
       //bad
       // 与えられた緯度経度に最も近いarrayの要素を返す
       // 地球が完全な球体であることを前提としている
       var findClosestLocation = function (lat, lng, array) {
           var closest;
           var closest_dist = Number.MAX_VALUE;
           for (var i = 0; i < array.length; i += 1) {
               // 2つの地点をラジアンに変換する
               var lat_rad = radians(lat);
               var lng_rad = radians(lng);
               var lat2_rad = radians(array[i].latitude);
               var lng2_rad = radians(array[i].lomgitude);
       
               // 「球面三角法の第二余弦定理」の公式を使う
               var dist = Math.acos(Math.sin(lat_rad) * Math.sin(lat2_rad) +
                                    Math.cos(lat_rad) * Math.cos(lat2_rad) *
                                    Math.cos(lon2_red - lng_rad));
               if (dist < closest_dist) {
                   closest = array[i];
                   closest_dist = dist;
               }
           }
           return closest;
       };
       
       // good
       // 無関係の下位問題を別メソッドにする →　2つの地点（軽度緯度）の球面距離を算出する
       var spherical_distance = function (lat1, lng1, lat2, lng2) {
                   // 2つの地点をラジアンに変換する
               var lat_rad = radians(lat);
               var lng_rad = radians(lng);
               var lat2_rad = radians(array[i].latitude);
               var lng2_rad = radians(array[i].lomgitude);
       
               // 「球面三角法の第二余弦定理」の公式を使う
               retunr Math.acos(Math.sin(lat_rad) * Math.sin(lat2_rad) +
                            Math.cos(lat_rad) * Math.cos(lat2_rad) *
                            Math.cos(lon2_red - lng_rad));
       };
       
       // 良かったこと
       // ・難しい処理を別メソッドにしたことで、コードが読みやすくなった。
       // ・spherical_distanceをメソッドに切り出したことで、spherical_distanceを個別にテストできる
       var findClosestLocation = function (lat, lng, array) {
           var closest;
           var closest_dist = Number.MAX_VALUE;
           for (var i = 0; i < array.length; i += 1) {
               var dist = spherical_distance(lat, lng, array[i].latitude, array[i].longotde);
               if (dist < closest_dist) {
                   closest = array[i];
                   closest_dist = dist;
               }
           }
           return closest;
       };
       ```

    - [ ]  プログラムの核となる基本的なタスクはメソッド化する
        - 複数のプロジェクトで使いまわしできる
    - [ ]  汎用コードを作る

       ```jsx
       // bad
       // サーバーをAjaxで呼び出してレスポンスを処理する
       ajax_post({
           url: 'http://example.com/submit',
           data: data,
           on_success: function (response_data) {
               var str = "{\n";
               for (var key in response_data) {
                   str += " " + key + " + response_data[key] + "\n";
               }
               alert(str + "}");
               
               // 引き続きresponse_dataの処理
           }
       });
       
       // good
       // 無関係の下位問題を別メソッドにする →　「ディクショナリをきれいに印字する」を別メソッドにする
       // 良かったこと
       // ・呼び出し側のコード（ajax_post）が完結になる
       // ・format_prettyが再利用できる
       // ・format_prettyの改善が簡単になる
       var format_pretty = function (obj) {
           var str = "{\n";
           for (var key in response_data) {
               str += " " + key + " + response_data[key] + "\n";
           }
           return str + "}";
       };
       
       ajax_post({
           url: 'http://example.com/submit',
           data: data,
           on_success: function (response_data) {
               alert(format_pretty(response_data));
               
               // 引き続きresponse_dataの処理
           }
       });
       
       // more_good
       // format_prettyに機能追加をした
       var format_pretty = function (obj, indent) {
           // null,undefind,文字列,非オブジェクトを処理する
           if (obj === null) return "null";
           if (obj === undefind) return "undefind";
           if (typeof obj === "string") return '"' + obj + '"';
           if (typeof obj !== "object") return String(obj);
           if (indent === undefind) indent = "";
       
           var str = "{\n";
           for (var key in obj) {
               str += indent + " " + key + " = ";
               str += format_pretty(obj[key], indent + " ") + "\n";
           }
           return str + indent + "}";
       };
       ```

        - 汎用コードは簡単に共有できるように特別なディレクトリを用意する
    - [ ]  プロジェクトに特化した機能から無関係の下位問題を抽出する

       ```python
       # bad
       # 新しいbusinessオブジェクト作って、name,url,date_createdを設定する
       bussiness = Business();
       bussiness.name = request.POST["name"]
       
       # nameを有効なurlに変換する
       url_path_name = business.name.lower()
       url_path_name = re.sub(r"['\.]", "", url_path_name)
       url_path_name = re.sub(r"[^a-z0-9]+", "-", url_path_name)
       url_path_name = url_path_name.strip("-")
       business.url = "/biz/" + url_path_name
       
       business.date_created = datetime.datetime.utcnow()
       bussiness.save_to_database()
       
       # good
       # 「nameを有効なurlに変換する」をメソッド化した
       CHARS_TO_REMOVE = re.compile(r"['\.]+")
       CHARS_TO_DASH = re.compile(r"[^a-z0-9]+")
       
       def make_url_friendly(text);
           text = text.lower()
           text = CHARS_TO_REMOVE.sub('', text)
           text = CHARS_TO_DASH.sub('-', text)
           return text.strip('-')
       
       bussiness = Business();
       bussiness.name = request.POST["name"]
       business.url = "/biz/" + make_url_friendly(business.name)
       business.date_created = datetime.datetime.utcnow()
       bussiness.save_to_database()
       ```
  - [ ]  必要応じてインターフェイスを整える
  
     ```python
     # bad
     user_info = { "username": "...", "passeord": "..." }
     user_str = json.dumps(user_info)
     cipher = Cipher("aes_128_cbc", key=PRIVATE_KEY, init_vector=INIT_VECTOR, op=ENCODE)
     encrypted_bytes = cipher.update(user_str)
     encrypted_bytes += cipher.final() # 現在の128ビットブロックをフラッシュする
     url = "http://example.com/?user_info=" + base64.urlsafe_b64encode(encrypted_bytes)
     
     # good
     # objをurlセーフな文字列に変換する処理をメソッド化した
     def url_safe_encrypt(obj);
         obj_str = json.dump(obj)
         cipher = Cipher("aes_128_cbc", key=PRIVATE_KEY, init_vector=INIT_VECTOR, op=ENCODE)
         encrypted_bytes = cipher.update(obj_str)
         encrypted_bytes += cipher.final() # 現在の128ビットブロックをフラッシュする
         return base64.urlsafe_b64encode(encrypted_bytes)
     
     user_info = { "username": "...", "passeord": "..." }
     url = "http://example.com/?user_info=" + url_safe_encrypt(user_info)
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

- 複数のタスクを行っているコードはないか
  - [ ]  タスクは小さくできないか
     ```jsx
     // bad
     var vote_changed = function (old_vote, new_vote)
     	var score = get_score();
     	
     	if (new_vote !== old_vote) {
     		if (new_vote === 'Up') {
     			score += (old_vote === 'Done' ? 2 : 1);
     		} else if (new_vote === 'Down') {
     			score += (old_vote === 'Up' ? 2 : 1);
     		} else if (new_vote === '') {
     			score += (old_vote === 'Up' ? -1 : 1);
     		}
     	}
     
     	set_score(score);
     };
     
     // good
     // 投票を数値にパースする処理を別メソッドにする
     // これでコードが楽に理解できるようになった
     var vote_value = function (vote) {
     	if (vote === 'Up') {
     		return +1;
     	}
     	if (vote === 'Down') {
     		return -1;
     	}
     	return 0;
     };
     
     var vote_changed = function (old_vote, new_vote) {
     	var score = get_score();
     	score -= vote_value(old_vote); // 古い値を削除する
     	score += vote_value(new_vote); // 新しい値を削除する
     
     	set_score(score);
     };
     ```
     
     ```jsx
     // bad
     // 1度に複数のタスクを行っている
     
     // location_infoディクショナリから値を抽出する
     var place = location_info["LocalityName"]; // "Santa Monica"
     
     // 都市の優先順位を調べる
     // 何も見つからない場合はデフォルトで"Midle-of-Nowhere"にする
     if (!place) {
     	place = location_info["SubAdministrativeAreaName"]; // "Los Angeles"
     }
     if (!place) {
     	place = location_info["AdministrativeAreaName"]; // "California"
     }
     if (!place) {
     	place = "Midle-of-Nowhere"
     } 
     
     // 国を取得する
     // なければ"Planet Earth"にする
     if (location_info["CountryName"]) {
     	place += "," + location_info["CountryName"]; // "USA"
     } else {
     	place += ",Planet Earth";
     }
     
     // placeを更新する
     return place;
     
     // good
     // 「1度に1つのタスク」を適用する
     
     // この後はlocation_infoを使用する必要がなくなったので、長いキーを覚える必要がなくなった
     var town = location_info["LocalityName"];
     var city = location_info["SubAdministrativeAreaName"];
     var state = location_info["AdministrativeAreaName"];
     var country = location_info["CountryName"];
     
     // 先にデフォルト値を設定して値が見つかったら書き換える
     var second_half = "Planet Earth";
     if (country) {
     	second_half = country;
     }
     if (state && country === "USA") {
     	second_half = state;
     }
     
     var first_half = "Midlle-ofNowhere"
     if (state && country !== "USA") {
     	first_half = state;
     }
     if (city) {
     	first_half = city;
     }
     if (town) {
     	first_half = town;
     }
     
     return first_half + ',' + second_half;
     ```

     ```java
     // bad
     void UpdateCounts(HttpDownload hd) {
     	// 可能であれば"Exit State"を見つける
     	if (!hd.has_event_log() || !hd.event_log().has_exit_state()) {
     		counts["Exit State"]["unknown"]++;
     	} else {
     		string state_str = ExitStateTypeName(hd.event_log().exit_state());
     		counts["Exit State"][state_str]++;
     	}
     
     	// HTTPヘッダーがなければ、残りの要素に"unknow"を設定する
     	if (!hd.has_http_headers()) {
     		counts["Http Response"]["unknow"]++;
     		counts["Content-Type"]["unknow"]++;
     		return;
     	}
     
     	HttpHeaders headers = hd.http_headers();
     
     	// HTTPレスポンスをログに記録する。なければ"unknow"と記録する。
     	if (!headers.has_response_code()) {
     		counts["Http Response"]["unknow"]++;
     	} else {
     		string code = StringPrintf("%d", headers.response_code());
     		counts["Http Response"][code]++;
     	}
     	
     	// "Content-Type"をログに記録する。なければ"unknow"と記録する。
     	if (!headers.has_content_type()) {
     		counts["Content-Type"]["unknow"]++;
     	} else {
     		string content_type = ContentTypeMime(headers.content_type());
     		counts["Content-Type"][content_type]++;
     	}
     }
     
     // good
     void UpdateCounts(HttpDownload hd) {
     	// タスク：抽出したい値をデフォルト値に設定する
     	string exit_state = "unknow";
     	string http_response = "unknow";
     	string content_type = "unknow";
     
     	// タスク：HttpDownloadから値を1つずつ抽出する
     	if (hd.has_event_log() && hd.event_log().has_exit_state()) {
     		exit_state = ExitStateTypeName(hd.event_log().exit_state());
     	}
     	if (hd.has_http_headers() && hd.http_headers().has_response_code()) {
     		http_response = StringPrintf("%d", headers.response_code());
     	}
     	if (hd.has_http_headers() && hd.http_headers().has_content_type()) {
     		content_type = ContentTypeMime(hd.http_headers().content_type());
     	}
     
     	// タスク:counts[]を更新する
     	counts["Exit State"][exit_state]++;
     	counts["Exit State"][http_response]++;
     	counts["Exit State"][content_type]++;
     }
     
     // more good
     // 変数（exit_state等）を削除できる
     void UpdateCounts(HttpDownload hd) {
     	counts["Exit State"][ExitState(hd)]++;
     	counts["Exit State"][HttpResponse(hd)]++;
     	counts["Exit State"][ContentType(hd)]++;
     }
     
     string ExitState(HttpDownload hd) {
     	if (hd.has_event_log() && hd.event_log().has_exit_state()) {
     		return ExitStateTypeName(hd.event_log().exit_state());
     	} else {
     		return "unknow";
     	}
     }
     ```

- コードに思いを込める
    - コードをより簡単にする手順
      1. コードの動作を簡単な言葉を使って同僚に説明する
      2. 説明の中で使っているキーワードやフレーズに注目する
      3. 説明に合わせてコードを書く
    - [ ] コードを声に出して説明する
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
        ```python
        # 初めのコード
        def PrintStockTransactions():
        	stock_iter = db_read("SELECT time, ticker_symbol FROM ...")
        	price_iter = ...
        	num_shares_iter = ...
        	
        	# 3つのテーブルの行を1度にイテレートする
        	while stock_iter and price_iter and num_shares_iter:
        		stock_time = stock_iter.time
        		price_time = price_iter.time
        		num_shares_time = num_shares_iter.time
        		
        		# 3つの行に同じtimeが含まれていない場合、最も過去の行をスキップする
        		# 注意：最も過去の行が2つ一致していることもあるので、<=は<にできない
        		if stock_time != price_time or stock_time != num_shares_time:
        			if stock_time <= price_time and stock_time <= num_shares_time:
        				stock_iter.NextRow()
        			elif price_time <= stock_time and price_time <= num_shares_time:
        				price_iter.NextRow()
        			elif num_shares_time <= stock_time and num_shares_time >= price_time:
        				num_shares_iter.NextRow()
        			else
        				assert False # 不可能
        			continue
        
        		assert stock_time == price_time == num_shares_time
        
        		# 一致した行を印字する
        		print "@", stock_time,
        		print stock_iter.ticker_symbol,
        		print price_iter.price,
        		print num_shares_iter.number_of_shares
        
        		stock_iter.NextRow()
        		price_iter.NextRow()
        		num_shares_iter.NextRow()
        
        # リファクタリング（1回目）
        def PrintStockTransactions():
        	stock_iter = db_read("SELECT time, ticker_symbol FROM ...")
        	price_iter = ...
        	num_shares_iter = ...
        	
        	while true
        		# 一番汚い処理を別メソッドにする
        		time = AdvanceToMatchingTime(stock_iter, price_iter, num_shares_iter)		
        		if time is None:
        			return
        
        		# 一致した行を印字する
        		print "@", stock_time,
        		print stock_iter.ticker_symbol,
        		print price_iter.price,
        		print num_shares_iter.number_of_shares
        
        		stock_iter.NextRow()
        		price_iter.NextRow()
        		num_shares_iter.NextRow()
        
        # 一番汚い処理をそのまま移管したので汚い
        def AdvanceToMatchingTime(stock_iter, price_iter, num_shares_iter)		
        	# 3つのテーブルの行を1度にイテレートする
        	while stock_iter and price_iter and num_shares_iter:
        		stock_time = stock_iter.time
        		price_time = price_iter.time
        		num_shares_time = num_shares_iter.time
        		
        		# 3つの行に同じtimeが含まれていない場合、最も過去の行をスキップする
        		if stock_time != price_time or stock_time != num_shares_time:
        			if stock_time <= price_time and stock_time <= num_shares_time:
        				stock_iter.NextRow()
        			elif price_time <= stock_time and price_time <= num_shares_time:
        				price_iter.NextRow()
        			elif num_shares_time <= stock_time and num_shares_time >= price_time:
        				num_shares_iter.NextRow()
        			else
        				assert False # 不可能
        			continue
        
        		assert stock_time == price_time == num_shares_time
        		return stock_time
        
        # リファクタリング（2回目）
        def AdvanceToMatchingTime(row_iter1, row_iter2, row_iter3):
        	while row_iter1 and row_iter2 and row_iter3:
        		t1 = row_iter1.time
        		t2 = row_iter2.time
        		t3 = row_iter3.time		
        	
        		if t1 == t2 == t3:
        			return t1
        	
        		tmax = max(t1,t2,t3)
        	
        		# いずれかの行が遅れているのであれば、その行をすすめる
        		# 最終的にすべての行が一致するまでループを繰り返す
        		if t1 < tmax: row_iter1.NextRow()
        		if t2 < tmax: row_iter2.NextRow()
        		if t3 < tmax: row_iter3.NextRow()
        
        	return None # 一致する行が見つからない
        ```

- 短いコードを書く
    - [ ]  不必要な機能は削除する。過剰な機能は不要。
    - [ ]  最も簡単に問題を解決できる要求（対応）を考える。
    - [ ]  定期的に全てのAPIを読んで、標準ライブラリを使えるようにする。

- テストを読みやすくて保守しやすいものにする
    
    ```cpp
    // docsをスコアでソートする（降順）。マイナスのスコアは削除する。
    void SortAndFilterDocs(vector<ScoredDocument>* docs);
    
    // first
    void Test1() {
    	vector<ScoredDocument> docs;
    	docs.resize(5);
    	docs[0].url = "http://example.com";
    	docs[0].score = -5.0;
    	docs[1].url = "http://example.com";
    	docs[1].score = 1;
    	docs[2].url = "http://example.com";
    	docs[2].score = 4;
    	docs[3].url = "http://example.com";
    	docs[3].score = -99998.7;
    	docs[4].url = "http://example.com";
    	docs[4].score = 3.0;
    
    	SortAndFilterDocs(&docs);
    
    	assert(docs.size() == 3);
    	assert(docs[1].score() == 4);
    	assert(docs[2].score() == 3.0);
    	assert(docs[3].score() == 1);
    }
    ```
    
    - 大切ではない詳細はユーザーから隠す。大切な詳細は目立つようにする。
        - `.score`、`.url`をヘルパーメソッドに出す
            
            ```cpp
            // second
            void MakeScoredDoc(ScoredDocument* sd, double score, string url) {
            	sd->score = score;
            	sd->url = url;
            }
            	
            void Test1() {
            	vector<ScoredDocument> docs;
            	docs.resize(5);
            	MakeScoredDoc(&docs[0], -5.0, "http://example.com");
            	MakeScoredDoc(&docs[1], 1, "http://example.com");
            	MakeScoredDoc(&docs[2], 4, "http://example.com");
            	MakeScoredDoc(&docs[3], -99998.7, "http://example.com");
            	...
            }
            ```
            
        - `&docs`をヘルパーメソッドに出す
            
            ```cpp
            // third
            void AddScoredDoc(vector<ScoredDocument>& docs, double score) {
            	ScoredDocument sd;
            	sd.score = score;
            	sd.url = "http://example.com";
            	docs.push_back(sd);
            }
            	
            void Test1() {
            	vector<ScoredDocument> docs;
            	AddScoredDoc(docs, -5.0);
            	AddScoredDoc(docs, 1);
            	AddScoredDoc(docs, 4);
            	AddScoredDoc(docs, -99998.7);
            	...
            }
            ```
            
        - 最小のテストを作る
            - テストコードが何を使用しているか簡単な言葉で説明する。
            - テストコードは、「こういう状況と入力から、こういう振る舞いと出力を期待する」のレベルまで要約できる。
        - 独自のミニ言語を実装する
            
            ```cpp
            // forth
            // CheckScoresBeforeAfterを呼び出すだけで、テストが書けるようになった。
            void CheckScoresBeforeAfter(string input, string expected_output) {
            	vector<ScoredDocument> docs = ScoreDocsFromString(input);
            	SortAndFilterDocs(&docs);
            	string output = ScoredDocsToString(docs);
            	assert(output == expected_output);
            }
            ```
            
    - エラーメッセージを読みやすくする
        - 読みやすいエラーメッセージを出力できるように
            - より良いassertを使う
            - 自作する
        - 読みやすいエラーメッセージ一例
            
            ```cpp
            // error message
            
            // bad
            Assertion failed: (output == expected_output),
            	function CheckScoresBeforeAfter, file test.cc, line 37.
            
            // good
            // 	outputとexpected_outputの値が見えることで、デバッグしやすくなる
            test.cc(37):fatal error in "CheckScoresBeforeAfter": critical check
            	output == expected_output failed "1,3,4" != "4,3,1"
            
            ```
            
    - テストの適切な入力値を選択する
        - コードを完全にテストする最も単純な入力値の組み合わせを選択する
            - 入力値を単純化する
                
                ```cpp
                // bad
                CheckScoresBeforeAfter("-5, 1, 4, -99998.7, 3", "4, 3, 1")
                
                //good
                //任意のマイナス値を表していた「-99998.7」を「-1」に単純化する
                CheckScoresBeforeAfter("-5, 1, 4, -1, 3", "4, 3, 1")
                ```
                
            - 1つの機能に複数のテスト
                - 完璧な入力値を一つ作るのではなく、小さなテストを複数作るほうが、
                    - 簡単
                    - 効果的
                    - 読みやすい
                    
                    ```cpp
                    // good
                    CheckScoresBeforeAfter("2, 1, 3", "3, 2, 1") // ソート
                    CheckScoresBeforeAfter("0, -0.1, -10", "0")  // マイナスは削除
                    ```
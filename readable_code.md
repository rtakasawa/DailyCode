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
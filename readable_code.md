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
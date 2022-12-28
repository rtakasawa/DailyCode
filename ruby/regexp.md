## Ruby:正規表現Tips

### ◯文字目を特定の文字に置き換える
- 例：3文字目を「い」に置き換える
```ruby
text = 'ああああああああああ'
text.sub(/^(.{2})(.)(.+)$/, '\1い\3')
# => "ああいあああああああ"
```

### 後方からの最短一致
- 例：最後の「，」を「及び」に置き換える
```ruby
text = 'A，B，C，D'
# 不要な部分を前方から最長でマッチさせればよいので、先頭に .*を加えている
text.sub(/^(.*)(，)(.*)$/, '\1及び\3')
# => "A，B，C及びD"
```
※引用記事：https://mell0w-5phere.net/jaded5phere/2018/07/01/regex-minimum-from-back/

### 正規表現にマッチした部分のみに特定の処理を行う
- 例：最後の「B」「C」を小文字に変換する
```ruby
text = 'A，B，C，D'
text.gsub(/[BC]/) {|str| str.downcase}
# => "A，b，c，D"
```

### 特定の文言以外にマッチさせる
- 例：最後の「B」「C」を小文字に変換する
```ruby
text = 'A，B，C，D'
text.gsub(/[BC]/) {|str| str.downcase}
# => "A，b，c，D"
```

### 任意の文字列を含まない文字列の正規表現
https://www-creators.com/archives/1827#appendix-1
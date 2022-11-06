# アダプタ

# 使い所（https://tech.mof-mof.co.jp/blog/adapter-pattern/から引用）
# あるモジュールについて、最初にざっくりと作ってしまったため、後からメソッドの引数の設計があんまりイケてなかったことに気が付いた。
# だけど、既にそのモジュールはあちこちで使われてしまっていて、メソッドの引数を全ての使用箇所で修正するのは非常にリスキー。
# 修正箇所を限定的にして、リスク少なく修正したいっていうケースに使えそう。
#
# あとは、クラス名とかメソッド名とかをtypoしていたことに相当後になってから気づいたとか、
# そういうケースでもtypoを修正したクラスを別途作って、旧クラスをadaptして共存させるっていうやり方をすれば安全に1つずつ修正が出来るようになりそう。

# サンプルソースの仕様
# ・Client:Printerクラスを使う側
# ・Printer:Clientが使っているメソッドを持つ
# ・OldPrinter:存在していたクラス
# ・変更前の状態だと、ClientはOldPrinterクラスを使えない
# →ClientがOldPrinterクラスを使えるようにする

# -----------コード-----------
# 変更前
class Printer
  def initialize(obj)
    @obj = obj
  end

  def print_weak
    @obj.print_weak
  end

  def print_strong
    @obj.print_strong
  end
end

class OldPrinter
  def initialize(string)
    @string = string.dup
  end

  def show_with_paren
    puts "（#{@string}）"
  end

  def show_with_aster
    puts "*#{@string}*"
  end
end

# 変更後
# ClientがOldPrinterクラスを使えるようにする
class Adapter
  def initialize(string)
    @old_printer = OldPrinter.new(string)
  end

  def print_weak
    @old_printer.show_with_paren
  end

  def print_strong
    @old_printer.show_with_aster
  end
end

# Client
p = Printer.new(Adapter.new("Hello"))
p.print_weak
#=> (Hello)
p.print_strong
#=> *Hello*

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-factory-method.html

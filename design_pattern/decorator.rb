# Decorator
# 既存のオブジェクトに対して簡単に機能を追加するためのパターン

# 構成要素
# 具体コンポーネント（ConcreteComponent）：ベースとなる処理を持つオブジェクト
# デコレーター（Decorator）：追加する機能をもつ

# 使い所
# 既存オブジェクトに機能を追加したい場合

# メリット
# - 既存オブジェクトの中身を変更することなく、機能を追加できる
# - 組み合わせで様々な機能を実現できる
# - 継承よりも変更お影響を限定しやすい

# サンプルソースの仕様
# - 既存のオブジェクトとして、ファイルへの単純な出力を行うSimpleWriterクラスがあり。
# - ファイルに「行番号出力を装飾する機能」と「タイムスタンプを追加する機能」を追加する

# -----------コード-----------
# 具体コンポーネント（ConcreteComponent）：ベースとなる処理を持つオブジェクト
class SimpleWriter
  def initialize(path)
    @file = File.open(path, "w")
  end

  # データ出力
  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  # file出力位置
  def pos
    @file.pos
  end

  def rewind
    @file.rewind
  end

  # fileを閉じる
  def close
    @file.close
  end
end

# Decoratorの共通部分を定義（Decoratorを複数作るため）
class WriteDecorator
  def initialize(real_writer)
    @real_writer = real_writer
  end

  def write_line(line)
    @real_writer.write_line(line)
  end

  def pos
    @real_writer.pos
  end

  def rewind
    @real_writer.rewind
  end

  def close
    @real_writer.close
  end
end

# 行番号出力を装飾する機能を持つ（Decorator）
class NumberingWriter < WriteDecorator
  # SimpleWriteオブジェクトを引数で受け取ることを想定
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  def write_line(line)
    # SimpleWriteオブジェクトのwrite_lineメソッドに処理を委譲している
    @real_writer.write_line("#{@line_number} : #{line}")
  end
end

# タイムスタンプを追加する機能を持つ（Decorator）
class TimestampingWriter < WriteDecorator
  def write_line(line)
    # SimpleWriteオブジェクトのwrite_lineメソッドに処理を委譲している
    @real_writer.write_line("#{Time.new} : #{line}")
  end
end

# 実行コード
# 既存のオブジェクト
writer = SimpleWriter.new('sample1.txt')
writer.write_line('飾り気のない一行')
writer.close

# 行番号出力を装飾する機能を持つ（Decorator）
f = NumberingWriter.new(SimpleWriter.new("file1.txt"))
f.write_line("Hello out there")
f.close
# file1.txtに以下の内容が出力される
#1 : Hello world

# タイムスタンプを装飾する機能を持つ（Decorator）
f = TimestampingWriter.new(SimpleWriter.new("file2.txt"))
f.write_line("Hello out there")
f.close
# file2.txtに以下の内容が出力される
#2012-12-09 12:55:38 +0900 : Hello out there

# 行番号とタイムスタンプを装飾する機能を持つ（Decorator）
f = TimestampingWriter.new(NumberingWriter.new(SimpleWriter.new("file3.txt")))
f.write_line("Hello out there")
f.close
# file3.txtに以下の内容が出力される
#1 : 2012-12-09 12:55:38 +0900 : Hello out there


# ※引用先
# https://morizyun.github.io/ruby/design-pattern-factory-method.html

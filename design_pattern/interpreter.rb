# Interpreter

# 使い所
# 構造木に沿った処理を実現する場合

# サンプルソース
# ファイル検索用のインタプリタ

# -----------コード-----------

# 命令・抽象的な表現（AbstractExpression)
class Expression
  def |(other)
    Or.new(self, other)
  end

  def &(other)
    And.new(self, other)
  end
end

# 全てのfile名を返す
require 'find'

class All < Expression
  def evaluate(dir)
    results = []
    # ディレクトリ内のfile名を収集
    # Find.findを使うことで、サブフォルダまで含めた全てのファイルを返す
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end

# 与えられたパターンとマッチする全てのファイル名を返す
class FillName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      # fileパスからfile名だけを抽出
      name = File.basename(p)
      # file名が@patternにマッチした場合trueを返す
      results << p if File.fnmatch(@pattern, name)
    end
    results
  end
end

# 指定したfileサイズより大きいファイルを返す
class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if (File.size(p) > @size)
    end
  end
end

# 書き込み可能なファイルを返す
class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if (File.writable?(p))
    end
    results
  end
end

# 書き込みできないファイルを探す
class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end

class Or < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    result1 = @expression1.evaluate(dir)
    result2 = @expression2.evaluate(dir)
    (result1 + result2).sort.uniq
  end
end

class And < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    result1 = @expression1.evaluate(dir)
    result2 = @expression2.evaluate(dir)
    (result1 + result2)
  end
end

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-factory-method.html

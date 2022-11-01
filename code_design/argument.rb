# 引数の順番を覚えなる責務をなくす方法

# パターン①
# ----------修正前----------
class Human
  def initialize(name, old, height, weight)
    @name = name
    @old = old
    @height = height
    @weight = weight
  end
end

# ----------修正後1----------
# 引数をhashで渡すことで、引数の順番を覚える必要がない
class Human
  def initialize(args)
    @name = args[:name]
    @old = args[:old]
    @height = args[:height]
    @weight = args[:weight]
  end
end

# ----------修正後2----------
class Human
  def initialize(args)
    # デフォルト値の設定もできる
    args = defaults.merge(args)

    @name = args[:name]
    @old = args[:old]
    @height = args[:height]
    @weight = args[:weight]
  end

  def defaults(args)
    {name: 'hi'}
  end
end


# パターン②：ライブラリ等、既に使用されている箇所がある場合
# ----------修正前----------
class Roo
  def initialize(cell, format)
    @cell = cell
    @format = format
  end
end

# ----------修正後----------
# ラップして、hashで引数を渡せるようにする
module RooWrapper
  def self.roo(args)
    @cell = args[:cell]
    @format = args[:format]
  end
end

# ファクトリーメソッド
# ・インスタンスの生成部分をサブクラスに任せるパターン
# ・インスタンスの生成部分を切り離すことで、結合度を下げて、追加、保守、変更を容易にする

# -----------初め-----------

# サックス
class Saxophone
  def initialize(name)
    @name = name
  end

  def play
    puts "サックス #{@name}は音を奏でます"
  end
end

# 楽器工場
class InstrumentFactory
  def initialize(number_saxophones)
    @saxophones = []
    # number_saxophonesで指定した本数分、サックスを作る
    number_saxophones.times do |i|
      saxophone = Saxophone.new("サックス #{i}")
      @saxophones << saxophone
    end
  end

  # 楽器を出荷する
  def ship_out
    @tmp = @saxophones.dup
    # 作成したサックスを出荷するので、サックスの在庫は空になる
    @saxophones = []
    # 作成した楽器を出荷（出力）
    @tmp
  end
end

# -----------変更-----------
# 楽器工場(InstrumentFactory)で、ギターも作ることになった

class Guitar
  def initialize(name)
    @name = name
  end

  def play
    puts "ギター #{@name}は音を奏でます"
  end
end

# -----------課題-----------
# ・今の楽器工場(InstrumentFactory)だとサックスしか作れない
# ・楽器を増やすたびに、楽器工場(InstrumentFactory)の変更が必要になる

# -----------対応-----------
# 楽器工場(InstrumentFactory)でサックスを作っている部分をサブクラスにて行う（ギターも同様）

# 楽器工場
class InstrumentFactory
  def initialize(number_instruments)
    @instruments = []
    number_instruments.times do |i|
      instrument = new_instrument(i)
      @instruments << instrument
    end
  end

  # 楽器を作るメソッド
  # サブクラスで具体的な処理を書く
  def new_instrument(number)
    NotImplementedError
  end

  # 楽器を出荷する
  def ship_out
    @tmp = @instruments.dup
    @instruments = []
    @tmp
  end
end

# サックスを作る
class SaxophoneFactory < InstrumentFactory
  # サックスを作るメソッド
  def new_instrument(name)
    Saxophone.new(name)
  end
end

# ギターを作る
class GuitarFactory < InstrumentFactory
  # ギターを作るメソッド
  def new_instrument(name)
    Guitar.new(name)
  end
end

# -----------メリット-----------
# ・楽器が増減しても、InstrumentFactoryクラスを修正する必要はない
# ・InstrumentFactoryクラスは、共通処理に専念できる

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-factory-method.html

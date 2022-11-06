# アブストラクトファクトリー

# ---------作る物---------
# ・池をサンプルとする
# ・池には動物と植物がいる
# ・動物は「アヒル」と「カエル」
# ・植物は「藻」と「スイレン」
# ・動物と植物の組み合わせは以下の通り
#   - 「アヒル」と「スイレン」
#   - 「藻」と「カエル」

# ---------コード---------
# 動物
class Duck
  def initialize(name)
    @name = name
  end

  def eat
    puts "アヒル #{@name}は食事中です"
  end
end

class Frog
  def initialize(name)
    @name = name
  end

  def eat
    puts "カエル #{@name}は食事中です"
  end
end

# 植物
class Algae # 藻
  def initialize(name)
    @name = name
  end

  def grow
    puts "藻 #{@name}は成長中です"
  end
end

class WaterLily # スイレン
  def initialize(name)
    @name = name
  end

  def grow
    puts "スイレン #{@name}は成長中です"
  end
end

# 池の生態系を作るクラス（Abstract Factory）
class OrganismFactory
  attr_reader :animals, :plants

  def initialize(number_animals, number_plants)
    # 池の動物を定義
    @animals = []
    number_animals.times do |i|
      animal = new_animal("動物 #{i}")
      @animals << animal
    end

    # 池の植物を定義
    @plants = []
    number_plants.times do |i|
      plant = new_plant("植物 #{i}")
      @plants << plant
    end
  end
end

# カエル(Frog)と藻(Algae)の生成を行う (Concrete Factory)
class FrogAndAlgaeFactory < OrganismFactory
  private

  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
    Algae.new(name)
  end
end

# アヒル(Duck)とスイレン(WaterLily)の生成を行う(Concrete Factory)
class DuckAndWaterLilyFactory < OrganismFactory
  private

  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
    WaterLily.new(name)
  end
end

# -----------メリット-----------
# ・関連するオブジェクトをまとめて生成できる
# ・整合性が必要となるオブジェクト群を誤りなしに生成できる

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-factory-method.html

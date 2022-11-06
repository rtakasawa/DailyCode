# Builder
# - Builder:オブジェクトを作る時に必要な作業を定義する（インターフェイスを定義する）
# - ConcreateBuilder:Builderに定義されたインターフェイスを使って、実際に作成するオブジェクト
# - Director:Builderで作成されたインターフェイスを使って、作業工程を定義するclass

# 使い所
# - オブジェクトを作る時に大量の処理が必要な場合

# サンプルソース1
## サンプルソースの仕様
## - 砂糖水の作成

## -----------コード-----------
class SugarWater
  attr_accessor :water, :sugar
  def initialize(water, sugar)
    @water = water
    @sugar = sugar
  end
end

# 砂糖水を作るための作業を定義する
class SugarWaterBuilder
  def initialize
    @sugar_water = SugarWater.new(0,0)
  end

  def add_sugar(sugar_amount)
    @sugar_water.sugar += sugar_amount
  end

  def add_water(water_amount)
    @sugar_water.water += water_amount
  end

  def result
    @sugar_water
  end
end

# 砂糖水を作るための作業工程を定義する
class Director
  def initialize(builder)
    @builder = builder
  end

  def cook
    @builder.add_water(150)
    @builder.add_sugar(90)
    @builder.add_water(300)
    @builder.add_sugar(35)
  end
end

# サンプルソース2
## サンプルソースの仕様
## - 砂糖水の作成
## - 塩水を作成する

## -----------コード-----------
class SaltWater
  attr_accessor :water, :salt
  def initialize(water, salt)
    @water = water
    @salt = salt
  end

  def add_material(salt_amount)
    @salt += salt_amount
  end
end

class SugarWater
  attr_accessor :water, :sugar
  def initialize(water, sugar)
    @water = water
    @sugar = sugar
  end

  def add_material(sugar_amount)
    @sugar += sugar_amount
  end
end

# SugarWaterBuilderを食塩水も作れるように「加工水クラス」変更
class WaterWithMaterialBuilder
  def initialize(class_name)
    @water_with_material = class_name.new(0,0)
  end

  def add_material(material_amount)
    @water_with_material.add_material(material_amount)
  end

  def add_water(water_amount)
    @water_with_material.water += water_amount
  end

  def result
    @water_with_material
  end
end

class Director
  def initialize(builder)
    @builder = builder
  end

  def cook
    @builder.add_water(150)
    @builder.add_material(90)
    @builder.add_water(300)
    @builder.add_material(35)
  end
end

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-factory-method.html

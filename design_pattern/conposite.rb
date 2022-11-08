# Composite
# - Compositeパターンには、コンポーネントクラス、リーフクラス、コンポジットクラスの3つの主要なクラスが存在する。
# - コンポーネントは基本クラスであり、すべてのコンポーネントに共通のインタフェースを定義する。
# - リーフは、プロセスの不可分な構成要素である。
# - コンポジットはサブコンポーネントから構成される上位のコンポーネントであり、コンポーネントであると同時にコンポーネントの集合体でもあるという二重の役割を果たす。
# - コンポジットクラスもリーフクラスも同じインタフェースを実装しているので、同じように使うことができます。
# - コンポジットクラスが任意の深さのツリーを作れるようにしておくことが重要となる。

# 使い所
# - 階層構造で表現されるオブジェクトの場合

# メリット
# - 木構造を伴う再帰的なデータ構造（ディレクトリ、ファイルシステム等）を表現できる
# - 階層構造で表現されるオブジェクトの取り扱いを楽にする

# サンプルソースの仕様
# - ケーキの製造過程を追跡するシステムの構築を依頼されました。
# - 重要な要件は、ケーキを焼くのにどれくらい時間がかかるかを知ることができることです。
# - ケーキの製造は、異なるサブタスクで構成されるかもしれない複数のタスクが含まれるため、複雑なプロセスです。
# - 全工程は以下のような木で表現できる。
# [image](https://github.com/rtakasawa/DailyCode/blob/master/images/factory_method.png)

# -----------コード-----------
# コンポーネント（共通の基本クラス）
class Task
  attr_accessor :name, :parent

  def initialize(name)
    @name = name
    @parent = nil
  end

  def get_time_required
    0.0
  end
end

# リーフクラス
class AddDryIngredientsTask < Task
  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0
  end
end

# コンポジットクラス
# 内部的にはいくつものサブタスクから構成されているが、外からは他のタスクと同じように見える複雑なタスクを扱うためのコンテナ
class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def add_sub_task(task)
    @sub_tasks << task
    task.parent = self
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
    task.parent = nil
  end

  def get_time_required
    @sub_tasks.inject(0.0) {|time, task| time += task.get_time_required}
  end
end

# コンポジットクラス（基底クラス）を使って、単純なタスクのように振る舞う複雑なタスクを作ることができる
# subtaskも追加できる
class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end
end

class MakeCakeTask < CompositeTask
  def initialize
    super('Make cake')
    # 複合的なタスクも追加できる
    add_sub_task(MakeBatterTask.new)
    add_sub_task(FillPanTask.new)
    add_sub_task(BakeTask.new)
    add_sub_task(FrostTask.new)
    add_sub_task(LickSpoonTask.new)
  end
end

# ※引用先
# https://github.com/rtakasawa/design-patterns-in-ruby/blob/master/composite.md

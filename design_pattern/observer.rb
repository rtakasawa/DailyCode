# Observer
# あるオブジェクトの状態が変化した際に、そのオブジェクト自身が「観察者」に「通知」するしくみです。
# オブザーバは次の3つのオブジェクトによって構成されます。
# - サブジェクト(subject)：変化する側のオブジェクト
# - オブザーバ(Observer)：状態の変化を関連するオブジェクトに通知するインタフェース
# - 具象オブザーバ(ConcreteObserver)：状態の変化に関連して具体的な処理を行う

# 使い所
# 次の条件を満たす場合にオブザーバパターンを使う。
# - オブジェクトの状態が変化する可能性がある
# - 変化したことをほかのオブジェクトに通知する必要がある
# ※例:Aで起きたイベントをB, Cが知る必要がある場合

# Observableモジュールを使って
# - Subject
#   - add_observerメソッドを使って、サブジェクトの変更を通知する必要があるオブジェクトを追加する
#   - changeメソッドとnotify_observersメソッドを使って、サブジェクトの変更を通知をadd_observerメソッドを使って追加したオブジェクトに通知できる

# サンプルソース
# Employeeオブジェクトにsalaryプロパティがある場合。
# 従業員の給与を変更し、その変更内容を給与システムに通知できるようにしたい。
# これを実現する最も簡単な方法は、payroll に参照を渡し、従業員の給与を変更するたびに通知すること。

# -----------コード-----------
require 'observer'

# 従業員
# サブジェクト(subject)
class Employee
  # Observerとして働く→ここでは「従業員のニュースを監視するしくみ」
  include Observable

  attr_reader :name, :title, :salary

  def initialize(name, title, salary)
    @name = name
    @salary = salary
    add_observer(Payroll.new)
    add_observer(TaxMan.new)
  end

  # 給与をセットして、ConcreteObserverに通知する→ConcreteObserverのupdateメソッドが呼ばれる
  def salary=(new_salary)
    @salary = new_salary
    notify_observers(self)
  end
end

# 給与の小切手の発行
# 具体オブザーバ(ConcreteObserver)
class Payroll
  def update(changed_employee)
    puts "彼の給料は#{changed_employee.salary}！#{changed_employee.title}のために新しい小切手を切ります。"
  end
end

# 税金の請求書の発行を行う
# 具体オブザーバ(ConcreteObserver)
class TaxMan
  def update(change_employee)
    puts "#{change_employee.name}に新しい税金の請求書を送る"
  end
end

# 実行
# johnのsalary(給与)を変更するとObservableによってPayrollクラスと、TaxManクラスのupdateメソッドが連動して動いていることがわかる。
john = Employee.new('John', 'Senior Vice President', 5000)
john.salary = 6000
#=> 彼の給料は6000になりました！Senior Vice Presidentのために新しい小切手を切ります。
#=> Johnに新しい税金の請求書を送ります
john.salary = 7000
#=> 彼の給料は7000になりました！Senior Vice Presidentのために新しい小切手を切ります。
#=> Johnに新しい税金の請求書を送ります

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-factory-method.html

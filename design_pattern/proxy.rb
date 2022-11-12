# Proxy

# 使い所
# - 1つのオブジェクトに複数の関心事がある場合に、関心事を分離するために使う
# - オブジェクトの本質的な目的とは異なる要件を分離できる

# サンプルソース
# - 銀行の窓口業務（入金/出金）を担当するBankAccountクラス
# - ユーザー認証を担当するBankAccountProxyクラス
# - BankAccountの生成を遅らせるVirtualAccountProxyクラス

# -----------コード-----------
# 銀行の入出金業務を行う（対応オブジェクト/subject）
class BankAccount
  attr_reader :balance

  def initialize(balance)
    puts "BankAccountを生成しました。"
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end

require 'etc'

# ユーザーログインを担当する防御Proxy
# Proxyオブジェクトは、subjectオブジェクトと同じインターフェイスを持つ
class BackAccountProxy
  def initialize(real_object, owner_name)
    @real_object = real_object
    @owner_name = owner_name
  end

  def balance
    check_access
    @real_object.balance
  end

  def deposit(amount)
    check_access
    @real_object.deposit(amount)
  end

  def withdraw(amount)
    check_access
    @real_object.withdraw(amount)
  end

  def check_access
    if (Etc.getlogin != @owner_name)
      raise "Illegal access: #{@owner_name} cannot access account"
    end
  end
end

# BankAccountの生成を遅らせる仮想Proxy
# （ここでは全体の性能向上を目的としている）
class VirtualAccountProxy
  def initialize(starting_balance)
    puts "VirtualAccountProxyを生成しました。BankAccountはまだ生成していません。"
    @starting_balance = starting_balance
  end

  def balance
    subject.balance
  end

  def deposit(amount)
    subject.deposit(amount)
  end

  def withdraw(amount)
    subject.withdraw(amount)
  end

  def announce
    "Virtual Account Proxyが担当するアナウンスです"
  end

  def subject
    @subject || (@subject = BankAccount.new(@starting_balance))
  end
end

# -----------実行コード-----------
account = BankAccount.new(100)
# Proxyオブジェクトを使って、subjectオブジェクトを使う
# （subjectオブジェクトを使うためには、認証が必須なので）
proxy = BackAccountProxy.new(account, "root")
puts proxy.deposit(50)

proxy = VirtualAccountProxy.new(100)
puts proxy.announce
puts proxy.deposit(100)

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-proxy.html

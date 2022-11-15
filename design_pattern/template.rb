# Template
# - 構成
#   - 骨格としての抽象的なベースクラス
#   - 実際の処理を行うサブクラス

# メリット
# - ベースクラスには「変わらないアルゴリズム」が書ける
# - サブクラスに「変化するロジック」を置ける

# 使い所
# - 2つのコードのやりたいこと（アルゴリズム）がほとんど同じで、一部を変えたい場合

# サンプルソースの仕様
# - レポートを出力する

# -----------コード-----------
# ベースクラス
# レポートを出力する
class Report
  def initialize
    @title = "heml report title"
    @text = ["report line 1", "report line 2", "report line 3"]
  end

  # レポートの出力基準を規定
  def output_report
    output_start
    output_body
    output_end
  end

  # レポートの先頭に出力
  def output_start
  end

  # レポートの本文の管理
  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  # 本文内のLINE出力部分
  # 個別クラスに規定するメソッドとして、個別クラスに規定されていない場合はErrorとする
  def output_line(line)
    raise 'Called abstract method !!'
  end

  # レポートの末尾に出力
  def output_end
  end
end

# サブクラス
# HTML形式でのレポート出力を行う
class HTMLReport < Report
  def output_start
    puts ""
  end

  def output_line(line)
    puts "#{line}"
  end

  def output_end
    puts ''
  end
end

# サブクラス
# PlaneText形式（`******`で囲う）でのレポート出力を行う
class PlaneReport < Report
  def output_start
    puts "********#{@title}*********"
  end

  def output_line(line)
    puts "#{line}"
  end
end

# 実行コード
report = HTMLReport.new
report.output_report

report = PlaneReport.new
report.output_report

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-template-method.html

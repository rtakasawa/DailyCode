# Strategy

# サンプルソース
# レポートをHTML形式とプレーンテキスト形式で作成するプログラム

# -----------コード-----------
# レポートの出力を抽象化したクラス(Strategy)
# rubyらしく書くなら不要（ダックタイピング）
class Formatter
  def output_report(title, text)
    raise 'Called abstract method !!'
  end
end

# HTML形式に整形して出力（ConcreteStrategy）
class HTMLFormatter < Formatter
  def output_report(context)
    puts "<html>"
    puts "<head>"
    puts "<title>#{context.title}</title>"

    context.text.each do |line|
      puts "<p>#{line}</p>"
    end
  end
end

# PlaneText形式に整形して出力（ConcreteStrategy）
class PlainTextFormatter < Formatter
  def output_report(context)
    puts "******#{context.title}*********"

    context.text.each do |line|
      puts line
    end
  end
end

# レポートを表す（Context）
class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = "Monthly Report"
    @text = ["Thing are going", "really, really well"]
    # 出力フォーマットを設定
    # formatterを変えれば、Report（Context）を変えることなく、出力形式（Strategy）を変えることができる
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self)
  end
end


# -----------実行コード-----------
report = Report.new(HTMLFormatter.new)
report.output_report
# =>
# <html>
# <head>
# <title>Monthly Report</title>
# <p>Thing are going</p>
# <p>really, really well</p>

report.formatter = PlainTextFormatter.new
report.output_report
# =>
# ******Monthly Report*********
# Thing are going
# really, really well

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-storategy.html
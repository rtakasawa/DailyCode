# Iterator
# 要素の集まりを持つオブジェクトの各要素に、順番にアクセスする方法

# 使い所
# - 要素の集まったオブジェクト（配列等）にアクセスする場合
# - 集合の要素に順にアクセスする必要がある

# サンプルソース

# -----------コード-----------
# 集約オブジェクトの中の要素（Blogクラスの個別の要素）
class Article
  attr_reader :title

  def initialize(title)
    @title = title
  end
end

# 集約オブジェクト
class Blog
  def initialize
    @articles = []
    @contents = []
  end

  # 指定のインデックス要素を返す
  def get_article_at(index)
    @articles[index]
  end

  # 要素を追加する
  def add_article(article)
    @articles << article
  end

  # 要素の数を返す
  def length
    @articles.length
  end

  # イテレーターの生成
  def iterator
    BlogIterator.new(self)
  end
end

class BlogIterator
  def initialize(blog)
    @blog = blog
    @index = 0
  end

  # 次のindex要素が存在するかtrue/falseで返す
  def has_next?
    @index < @blog.length
  end

  # indexを1つ進めて,次のArticleクラスを返す
  def next_article
    article = self.has_next? ? @blog.get_article_at(@index) : nil
    @index = @index + 1
    article
  end
end

# ※引用先
# https://morizyun.github.io/ruby/design-pattern-factory-method.html

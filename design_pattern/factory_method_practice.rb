# ファクトリーメソッドの練習

# 作る物：複数の文書をインポートする

# Creator（共通部分の処理）
class DocumentsImporter
  def initialize(files)
    @documents = []

    files.times do |file|
      document = new_document(file)
      @documents << document
    end
  end

  # 抽象メソッド
  def new_document(name)
    raise NotImplementedError
  end

  def import
    @documents.each do |document|
      document.import
    end
  end
end

# ConcreteCreator（実際にオブジェクトの生成をする）
class PdfImporter < DocumentsImporter
  def new_document(file)
    Pdf.new(file)
  end
end

class WordImporter < DocumentsImporter
  def new_document(file)
    Word.new(file)
  end
end

# Product（生成されるオブジェクト）
class Pdf
  def initialize(file)
    @file = file
  end

  def import
    # pdf独自のインポート処理
  end
end

class Word
  def initialize(file)
    @file = file
  end

  def import
    # word独自のインポート処理
  end
end

# 呼び出し例
class FilesController
  def create_pdf
    files = params(files)
    PdfImporter.new(files)
  end

  def create_word
    files = params(files)
    WordImporter.new(files)
  end
end

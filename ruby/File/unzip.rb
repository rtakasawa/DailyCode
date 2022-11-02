# zip_fileを解凍して,中身（file）をDB（ActiveStorage）に保存する

def unzipping_and_save_files(response_body, db)
  Zip::File.open_buffer(response_body) do |zf|
    zf.each do |entry|
      # ----------ファイル名の取得----------
      # [entry.name]に文字コードが混ざっていたことがあったので、encodeしている
      file_name = entry.name.encode('UTF-8', 'UTF-8')

      # file名だけ取得したい場合
      file_name = file_name.name.match(%r{/(.+)$})[1]

      ## フォルダ名もfilenameに含めたい場合の対応
      ## ・File.binwriteでErrorになるので、「\」をアンダーバーに変換
      # file_name.tr!('\\', '_')

      # ----------ファイルの中身を取得----------
      file_binary = entry.get_input_stream.read

      # ----------fileをDB（ActiveStorage）に保存----------
      # fileを直接DBに保存できず、以下手順でDBに保存した
      # ①fileをtmpディレクトリに出力
      file_path = "tmp/#{file_name}"
      File.binwrite(file_path, file_binary)
      # ②tmpディレクトリに出力したfileをDBに保存
      db.files.attach(io: File.open(file_path, 'rb'), filename: file_name)
      # ③tmpディレクトリに出力したfileを削除
      File.delete(file_path)
    end
  end
end

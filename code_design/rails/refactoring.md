# アプリケーションの複雑性に立ち向かう
## 第一の鍵-然るべきところにコードを書く
### コントローラー
#### モデルに書くべきコードをモデルに寄せる
##### 寄せるべきコードの具体例
- 変わった形式のparamsからの代入コード
  - 修正前
    ```ruby
    class UsersController < ApplicationController
      def create
        @user = User.new(user_params)
        # パラメータを郵便番号の形式に整えて、代入
        @user.zip_code = params[:zip1].present? && params[:zip2].present? ? [params[:zip1], params[:zip2]].join('-') : nil
        
        if @user.save
          redirect_to user_url(@user)
        else
          # 検証エラーになった場合に再表示をケア
          @zip1 = params[:zip1]
          @zip2 = params[:zip2]
          render :new
        end
      end
    
      def edit
        @user = User.new(params[:id])
        # 編集画面のために、フォームに合わせた形式にデータを分割する
        @zip1 = @user.zip_code.present? ? @user.zip_code.split('-').first : nil
        @zip2 = @user.zip_code.present? ? @user.zip_code.split('-').last : nil
      end
      
      def user_params
        params.require(:user).permit(:name, ・・・・)
      end
    end
    ```
  - 修正後
    ```ruby
    # 画面の都合に合わせたリクエストパラメーターをモデル側で受け取る
    # モデル側でデータベースの形式に変換する
    class User
      # 画面の都合に合わせたリクエストパラメーターをモデル側で用意
      attr_reader :zip1, :zip2
      # 検証前にzip1,zip2を合算してzip_codeにする
      before_validation :set_zip_code
      
      def zip1
        @zip ||= zip_code.present? ? zip_code.split('-').first : nil
      end
      
      def zip2
        @zip2 ||= zip_code.present? ? zip_code.split('-').last : nil
      end
      
      private
      
      def set_zip_code
        self.zip_code = zip1.present? && zip2.present? ? [zip1, zip2].join('-') : nil
      end
    end
    ```
    ```ruby
    class UsersController < ApplicationController
      def create
        # モデル側でzip1,zip2を定義しているので、paramsで一括で受け取れる 
        @user = User.new(user_params)
        if @user.save
          redirect_to user_url(@user)
        else
          render :new
        end
      end
    
      def edit
        @user = User.new(params[:id])
      end
      
      def user_params
        params.require(:user).permit(:name, ・・・・)
      end
    end
    ```

  - オブジェクトの内部状態を変更するコード
  - モデルの検索条件を作るコード
  - モデルを操作するために必要な情報を揃えるための準備的な処理

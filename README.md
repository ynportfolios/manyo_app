## テーブルスキーマ
* User
  - name string
  - email string
  - password_digest string
* Task
  - user_id bigint
  - name string
  - content text
  - deadline datetime
  - priority integer
  - status integer
* Labelling
  - task_id bigint
  - label_id bigint
* Label
  - name string

## デプロイ手順
* アセットプリコンパイルをする
  - rails assets:precompile RAILS_ENV=production
* Gitにコミットする
  - git add -A
  - git commit -m "任意のメッセージ"
* Herokuに新しいアプリケーションを作成する
  - heroku create
* Heroku stackを変更する
  - heroku stack:set heroku-18
* Heroku buildpackを追加する
  - heroku buildpacks:set heroku/ruby
  - heroku buildpacks:add --index 1 heroku/nodejs
* Herokuにデプロイする
  - git push heroku master
* Herokuデータベースのテーブルを作成する
  - heroku run rails db:migrate
* アプリケーション名を確認する
  - heroku config
* アプリケーションにアクセスする（ブラウザで実行）
  - https://アプリ名.herokuapp.com/

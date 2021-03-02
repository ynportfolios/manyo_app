require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    @normal = FactoryBot.create(:normal)
    visit new_session_path
    fill_in 'Email', with: 'normal@example.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'
  end
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
      # 1. new_task_pathに遷移する（新規作成ページに遷移する）
      # ここにnew_task_pathにvisitする処理を書く
      visit new_task_path
      # 2. 新規登録内容を入力する
      #「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄にタスクのタイトルと内容をそれぞれ入力する
      # ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
      fill_in 'タスク名', with: 'task_name'
      # ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
      fill_in 'タスク詳細', with: 'task_content'
      fill_in '終了期限', with: DateTime.new(2021, 3, 1, 1, 1)
      select '未着手', from: 'ステータス'
      # 3. 「登録する」というvalue（表記文字）のあるボタンをクリックする
      # ここに「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
      click_on '登録する'
      # 4. clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
      # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
      # ここにタスク詳細ページに、テストコードで作成したデータがタスク詳細画面にhave_contentされているか（含まれているか）を確認（期待）するコードを書く
      expect(page).to have_content 'task_name'
      expect(page).to have_content 'task_content'
      expect(page).to have_content '2021-03-01'
      expect(page).to have_content '未着手'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを作成
        task = FactoryBot.create(:task, name: 'task_name', user_id: @normal.id)
        # タスク一覧ページに遷移
        visit tasks_path
        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか（含まれているか）ということをexpectする（確認・期待する）
        expect(page).to have_content 'task_name'
        # expectの結果が true ならテスト成功、false なら失敗として結果が出力される
      end
    end
    # テスト内容を追加で記載する
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        # ここに実装する
        task_old = FactoryBot.create(:task, name: 'task_old', created_at: DateTime.new(2021, 3, 1, 1, 2), user_id: @normal.id)
        task_new = FactoryBot.create(:task, name: 'task_new', created_at: DateTime.new(2021, 3, 1, 1, 3), user_id: @normal.id)
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'task_new'
        expect(task_list[1]).to have_content 'task_old'
      end
    end
    context 'タスクが終了期限の降順に並んでいる場合' do
      it '終了期限が遠いタスクが一番上に表示される' do
        # ここに実装する
        task_1 = FactoryBot.create(:task, name: 'task_1', deadline: DateTime.new(2021, 3, 1, 1, 3), user_id: @normal.id)
        task_2 = FactoryBot.create(:task, name: 'task_2', deadline: DateTime.new(2021, 3, 1, 1, 2), user_id: @normal.id)
        visit tasks_path
        click_on '終了期限でソートする'
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'task_1'
        expect(task_list[1]).to have_content 'task_2'
      end
    end
    context 'タスクが優先順位の降順に並んでいる場合' do
      it '優先順位が高いタスクが一番上に表示される' do
        # ここに実装する
        task_1 = FactoryBot.create(:task, name: 'task_1', created_at: DateTime.new(2021, 3, 1, 1, 2), priority: 2, user_id: @normal.id)
        task_2 = FactoryBot.create(:task, name: 'task_2', created_at: DateTime.new(2021, 3, 1, 1, 3), priority: 1, user_id: @normal.id)
        visit tasks_path
        click_on '優先順位でソートする'
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'task_1'
        expect(task_list[1]).to have_content 'task_2'
      end
    end
  end
  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, name: 'task_name', content: 'task_content', user_id: @normal.id)
        visit task_path(id: task.id)
        expect(page).to have_content 'task_name'
        expect(page).to have_content 'task_content'
       end
     end
  end
  describe '検索機能' do
    before do
      # 必要に応じて、テストデータの内容を変更して構わない
      FactoryBot.create(:task, name: "task", status: 1, user_id: @normal.id)
      FactoryBot.create(:task, name: "sample", status: 2, user_id: @normal.id)
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        visit tasks_path
        # タスクの検索欄に検索ワードを入力する (例: task)
        fill_in 'task_name_field', with: 'task'
        # 検索ボタンを押す
        click_on '検索'
        expect(page).to have_content 'task'
        expect(page).to_not have_content 'sample'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # ここに実装する
        # プルダウンを選択する「select」について調べてみること
        visit tasks_path
        select '未着手', from: 'status_field'
        click_on '検索'
        expect(page).to have_content 'task'
        expect(page).to_not have_content 'sample'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        # ここに実装する
        visit tasks_path
        fill_in 'task_name_field', with: 'sample'
        select '着手', from: 'status_field'
        click_on '検索'
        expect(page).to have_content 'sample'
        expect(page).to_not have_content 'task'
      end
    end
  end
end
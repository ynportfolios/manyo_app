require 'rails_helper'
RSpec.describe 'ユーザ管理機能', type: :system do
  before do
    @normal = FactoryBot.create(:normal)
    @admin = FactoryBot.create(:admin)
  end
  describe 'ユーザ登録' do
    context 'ユーザを新規作成した場合' do
      it '作成したユーザの詳細ページが表示される' do
        visit new_user_path
        fill_in 'Name', with: 'test'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_on '登録する'
        expect(page).to have_content 'ログインしました'
        expect(page).to have_content 'testのページ'
        expect(page).to have_content 'test@example.com'
      end
    end
    context 'ユーザがログインしないでタスク一覧画面に飛ぼうとした場合' do
      it 'ログイン画面に遷移する' do
        visit tasks_path
        expect(page).to have_content 'ログインしてください'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Password'
      end
    end
  end
  describe 'セッション機能' do
    before do
      visit new_session_path
      fill_in 'Email', with: 'normal@example.com'
      fill_in 'Password', with: 'password'
      click_on 'Log in'
    end
    context '正しいユーザ情報を入力した場合' do
      it 'ログインできる' do
        expect(page).to have_content 'ログインしました'
        expect(page).to have_content 'normalのページ'
        expect(page).to have_content 'normal@example.com'
      end
      it 'ログアウトできる' do
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
        expect(page).to have_content 'ログイン'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Password'
      end
      it 'マイページに飛べる' do
        click_on 'マイページ'
        expect(page).to have_content 'normalのページ'
        expect(page).to have_content 'normal@example.com'
      end
    end
    context '一般ユーザが他人の詳細画面に飛んだ場合' do
      it 'タスク一覧画面に遷移する' do
        visit user_path(id: @admin.id)
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content 'タスク名'
        expect(page).to have_content 'タスク詳細'
        expect(page).to have_content '終了期限'
        expect(page).to have_content '登録日時'
        expect(page).to have_content 'ステータス'
        expect(page).to have_content '優先順位'
      end
    end
    describe '管理機能' do
      context '正しいユーザ情報を入力した場合' do
        it '管理画面にアクセスできる' do
          visit new_session_path
          fill_in 'Email', with: 'admin@example.com'
          fill_in 'Password', with: 'password'
          click_on 'Log in'
          click_on '管理画面'
          expect(page).to have_content 'ユーザ一覧'
          expect(page).to have_content 'ユーザ名'
          expect(page).to have_content 'タスク数'
          expect(page).to have_content '管理者権限'
        end
        it 'ユーザの新規登録ができる' do
          visit new_session_path
          fill_in 'Email', with: 'admin@example.com'
          fill_in 'Password', with: 'password'
          click_on 'Log in'
          click_on '管理画面'
          click_on 'ユーザを登録する'
          fill_in 'Name', with: 'test'
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_on '登録する'
          expect(page).to have_content 'testのページ'
          expect(page).to have_content 'test@example.com'
        end
        it 'ユーザの詳細画面にアクセスできる' do
          visit new_session_path
          fill_in 'Email', with: 'admin@example.com'
          fill_in 'Password', with: 'password'
          click_on 'Log in'
          click_on '管理画面'
          click_on "詳細", match: :first
          expect(page).to have_content 'normalのページ'
          expect(page).to have_content 'normal@example.com'
        end
        it 'ユーザを編集できる' do
          visit new_session_path
          fill_in 'Email', with: 'admin@example.com'
          fill_in 'Password', with: 'password'
          click_on 'Log in'
          click_on '管理画面'
          click_on "編集", match: :first
          fill_in 'Name', with: 'changed_normal'
          fill_in 'Email', with: 'changed_normal@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_on '更新する'
          expect(page).to have_content 'changed_normalのページ'
          expect(page).to have_content 'changed_normal@example.com'
        end
        it 'ユーザを削除できる' do
          visit new_session_path
          fill_in 'Email', with: 'admin@example.com'
          fill_in 'Password', with: 'password'
          click_on 'Log in'
          click_on '管理画面'
          click_on "削除", match: :first
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content 'ユーザを削除しました'
          expect(page).to_not have_content 'changed_normal'
        end
      end
      context '正しくないユーザ情報を入力した場合' do
        it '管理画面にアクセスできない' do
          visit new_session_path
          fill_in 'Email', with: 'normal@example.com'
          fill_in 'Password', with: 'password'
          click_on 'Log in'
          visit admin_users_path
          expect(page).to have_content '管理者以外はアクセスできません'
          expect(page).to have_content 'タスク一覧'
          expect(page).to have_content 'タスク名'
          expect(page).to have_content 'タスク詳細'
          expect(page).to have_content '終了期限'
          expect(page).to have_content '登録日時'
          expect(page).to have_content 'ステータス'
          expect(page).to have_content '優先順位'
        end
      end
    end
  end
end
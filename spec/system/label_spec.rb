require 'rails_helper'
RSpec.describe 'ラベル管理機能', type: :system do
  before do
    normal = FactoryBot.create(:normal)
    visit new_session_path
    fill_in 'Email', with: "normal@example.com"
    fill_in 'Password', with: "password"
    click_on 'Log in'
  end

  describe 'ラベル登録機能' do
    before do
      FactoryBot.create(:label_0)
      FactoryBot.create(:label_1)
      visit new_task_path
      fill_in 'タスク名', with: 'task_name'
      fill_in 'タスク詳細', with: 'task_content'
      fill_in '終了期限', with: DateTime.new(2021, 3, 1, 1, 1)
      select '未着手', from: 'ステータス'
      select '低', from: '優先順位'
      check 'label_0'
      click_on '登録する'
    end
    context 'ラベルを選択し、タスクを作成した場合' do
      it '選択したラベルがタスク一覧ページに表示される' do
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content "label_0"
        expect(task_list[0]).not_to have_content "label_1"
        end
      end
    context 'タスク一覧ページにてラベルを検索した場合' do
      it '検索したラベルに関するタスクのみが表示される' do
        visit new_task_path
        fill_in 'タスク名', with: 'task_name'
        fill_in 'タスク詳細', with: 'task_content'
        fill_in '終了期限', with: DateTime.new(2021, 3, 1, 1, 1)
        select '未着手', from: 'ステータス'
        select '低', from: '優先順位'
        check 'label_1'
        click_on '登録する'
        visit tasks_path
        select 'label_0', from: 'label_id'
        click_on 'ラベルで検索'
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content "label_0"
        expect(task_list[0]).not_to have_content "label_1"
        expect(task_list.size).to eq(1)
     end
    end
  end
end
FactoryBot.define do
  factory :task do
    # 下記の内容は実際に作成するカラム名に合わせて変更してください
    name { 'test_name' }
    content { 'test_content' }
    deadline { DateTime.new(2021, 3, 1, 1, 1) }
  end
end

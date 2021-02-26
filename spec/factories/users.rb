FactoryBot.define do
  factory :normal, class: User do
    name { 'normal' }
    email { 'normal@example.com' }
    password { 'password' }
  end
end

FactoryBot.define do
  factory :normal, class: User do
    name { 'normal' }
    email { 'normal@example.com' }
    password { 'password' }
  end
  factory :admin, class: User do
    name { 'admin' }
    email { 'admin@example.com' }
    password { 'password' }
    admin_flg { true }
  end
end

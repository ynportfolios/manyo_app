1.times do |n|
  User.create!(
    name: "admin",
    email: "admin@example.com",
    admin_flg: true,
    password: "password"
  )
end
1.times do |n|
  User.create!(
    name: "test#{n}",
    email: "test#{n}@example.com",
    password: "password"
  )
end
5.times do |n|
  Label.create!(
    name: "label#{n}"
  )
end
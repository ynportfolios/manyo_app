20.times do |n|
  User.create!(
    name: "test#{n}",
    email: "test#{n}@example.com",
    password: "password"
  )
end
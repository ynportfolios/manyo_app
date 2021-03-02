1.times do |n|
  User.create!(
    name: "admin",
    email: "admin@example.com",
    admin_flg: true,
    password: "password"
  )
end
9.times do |n|
  User.create!(
    name: "test#{n}",
    email: "test#{n}@example.com",
    password: "password"
  )
end
10.times do |n|
  Label.create!(
    name: "label_#{n}"
  )
end
User.all.each do |user|
  user.tasks.create!(
    name: "task_#{user.id}",
    content: "task_#{user.id}",
    deadline: DateTime.new(2021, 3, 1, 1, 1),
    status: rand(0..3),
    priority: rand(0..2)
  )
end
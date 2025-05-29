User.create!(
  name: 'takeshi',
  email: 'test@gmail.com',
  password: 'test123',
  password_confirmation: 'test123',
  confirmed_at: Time.current
)

5.times do |n|
  name = Faker::Name.unique.name
  email = "test#{n+1}@gmail.com"
  password = 'password'
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.current
  )
end

users = User.order(:created_at).take(6)

users.each do |user| 
  3.times do
    title_today = Faker::Lorem.sentence(word_count: rand(2..5))
    description_today = Faker::Lorem.paragraph(sentence_count: 2)

    # todayのタスクを作成
    user.todos.create!(
      title: title_today,
      description: description_today,
      due_at: Time.current,
      done: false
    )
    # そのほかの日程作成
    title = Faker::Lorem.sentence(word_count: rand(2..5))
    description = Faker::Lorem.paragraph(sentence_count: 2)

    user.todos.create!(
      title: title,
      description: description,
      due_at: Time.current + rand(-3..7).days,
      done: false
    )
  end  
end
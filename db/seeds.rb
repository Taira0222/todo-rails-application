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
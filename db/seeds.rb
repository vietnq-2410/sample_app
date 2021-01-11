User.create!(name: "Nguyen Quoc Viet",
             email: "viet@viet.com",
             password: "123123123",
             password_confirmation: "123123123",
             admin: true)
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

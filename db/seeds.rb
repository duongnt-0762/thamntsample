# Create a main sample user.
User.create!(name: "tham",
			email: "nttham98@gmail.com",
			password: "thamtham",
			password_confirmation: "thamtham",
			admin: true)
# Generate a bunch of additional users.
99.times do |n|
	name = Faker::Name.name
	email = "example-#{n+1}@railstutorial.org"
	password = "password"
	User.create!(name: name,
				email: email,
				password: password,
				password_confirmation: password)
end
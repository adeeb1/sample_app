namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_microposts
		make_relationships
	end
end

def make_users
	admin = User.create!(name: "Example User",
						 email: "example@railstutorial.org",
						 password: "foobar",
						 password_confirmation: "foobar")

	admin.toggle!(:admin)

	99.times do |n|
		name = Faker::Name.name
		email = "example-#{n+1}@railstutorial.org"
		password = "password"

		User.create!(name: name,
					 email: email,
					 password: password,
					 password_confirmation: password)
	end
end

def make_microposts
	users = User.all(limit: 6)

	50.times do
		content = Faker::Lorem.sentence(5)
		users.each { |user| user.microposts.create!(content: content) }
	end
end

def make_relationships
	# Get an array of all the users
	users = User.all

	# Get the first user in the array
	user = users.first

	# Get user #'s 3 - 51 (zero-based indices)
	followed_users = users[2..50]

	# Get user #'s 4 - 41
	followers 	   = users[3..40]

	# Loop through each user in the followed_users array and have the first user follow each one
	followed_users.each { |followed| user.follow!(followed) }

	# Loop through each user in the followers array and have them follow the first user
	followers.each { |follower| follower.follow!(user) }
end
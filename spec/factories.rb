FactoryGirl.define do
	factory :user do
		name					"Alexander Deeb"
		email					"adeeb@something.com"
		password 				"foobar"
		password_confirmation 	"foobar"
	end
end
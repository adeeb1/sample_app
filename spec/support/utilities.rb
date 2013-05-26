include ApplicationHelper

def sign_in(user)
	visit signin_path

	fill_in "Email", with: user.email
	fill_in "Password", with: user.password

	click_button "Sign in"

	# Sign in when not using Capybara as well
	cookies[:remember_token] = user.remember_token
end

def valid_signin(user)
	# Uppercase the user's email address to make sure our ability to find the user in the database is case-insensitive
	fill_in "Email", 	with: user.email.upcase
	fill_in "Password", with: user.password

	click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end

RSpec::Matchers.define :have_success_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-success', text: message)
	end
end
require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "signup page" do
  	before { visit signup_path }

  	it { should have_selector('h1', text: 'Sign up') }
  	it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  describe "profile page" do
    # Create a user variable using the FactoryGirl gem
  	let (:user) { FactoryGirl.create(:user) }

    # Visit the specific user's profile page before the tests
  	before { visit user_path(user) }

    # Make sure the 'h1' and 'title' tag values are set to
    # the user's name
  	it { should have_selector('h1', 	text: user.name) }
  	it { should have_selector('title', 	text: user.name) }
  end
end
require 'spec_helper'

def CheckH1TitleTags(h1value, titlevalue)
  subject { page }

  it { should have_selector('h1',    text: "#{h1value}") }
  it { should have_selector('title', text: "#{titlevalue}") }
end

describe "User pages" do
  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }

        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "signup page" do
  	before { visit signup_path }

    CheckH1TitleTags('Sign up', 'Sign up')
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        # Click on the "Create my account" button
        before { click_button submit }

        # Assign the :user symbol to the user found from the supplied email address
        let(:user) { User.find_by_email('user@example.com') }

        # Make sure the title of the page is the user's name
        it { should have_selector('title', text: user.name) }

        # Make sure the text in the div.alert.alert-success selector is "Welcome"
        it { should have_success_message('Welcome') }

        # Make sure the "Sign out" link is present
        it { should have_link('Sign out') }
      end
    end
  end

  describe "profile page" do
    # Create a user variable using the FactoryGirl gem
  	let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    # Visit the specific user's profile page before the tests
  	before { visit user_path(user) }

    # Make sure the 'h1' and 'title' tag values are set to
    # the user's name
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    
    # Sign the user in and then visit the edit path afterwards
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }

      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password

        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
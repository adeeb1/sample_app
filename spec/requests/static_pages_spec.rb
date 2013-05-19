require 'spec_helper'

describe "Static pages" do

  # Set the subject of all tests to the current webpage
  subject { page }

  describe "Home page" do
    # Visit the root path before each example
    before { visit root_path }

    it { should have_selector('h1',    text: 'Sample App') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "Help page" do
    # Visit the help path before each example
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title',
         text: full_title('Help')) }
  end

  describe "About page" do
    # Visit the about path before each example
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title',
         text: full_title('About Us')) }
  end

  describe "Contact page" do
    # Visit the contact path before each example
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title',
         text: full_title('Contact')) }
  end
end
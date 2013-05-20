require 'spec_helper'

def checkvalue(heading, page_title)
  # Set the subject of all tests to the current webpage
  subject { page }

  # Check the h1 and title tag values
  it { should have_selector('h1',    text: heading) }
  it { should have_selector('title', text: page_title) }
end

def testlink(urlText, shortTitle)
    # Click on the link
    click_link urlText

    # Make sure the title of the page matches
    page.should have_selector('title',
                text: full_title(shortTitle))
end

describe "Static pages" do
  # Set the subject of all tests to the current webpage
  subject { page }

  describe "Home page" do
    # Visit the webpage's path before each action
    before { visit root_path }

    checkvalue('Sample App', '')
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "Help page" do
    before { visit help_path }

    checkvalue('Help', 'Help')
  end

  describe "About page" do
    before { visit about_path }

    checkvalue('About', 'About Us')
  end

  describe "Contact page" do
    before { visit contact_path }

    checkvalue('Contact', 'Contact')
  end

  # Test that some links on certain pages go to the correct
  # URL
  it "should have the right links on the layout" do
      visit root_path

      testlink("About", 'About Us')
      testlink("Help", 'Help')
      testlink("Contact", 'Contact')

      click_link "Home"

      testlink("Sign up now!", 'Sign up')
      testlink("sample app", '')
  end
end
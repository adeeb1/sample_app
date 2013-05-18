require 'spec_helper'

def checkvalue(message, url, selector, text)
  it "#{message}" do
    # Visit the specified URL
    visit url

    # Concatenate the page's name to the end of the default
    # "Ruby on Rails Tutorial Sample App" text if the
    # selector is a 'title' tag
    if (selector == 'title')
      text = "Ruby on Rails Tutorial Sample App" + text
    end

    # Check if the specified selector ('h1' or 'title')
    # contains the value of 'text'
    page.should have_selector(selector, :text => text)
  end
end

def checknovalue(message, url, selector, text)
  it "#{message}" do
    # Visit the specified URL
    visit url

    # Check if the specified selector ('h1' or 'title')
    # does NOT contain the value of 'text'
    page.should_not have_selector(selector, :text => text)
  end
end

describe "Static pages" do

  describe "Home page" do
    
    checkvalue("should have the h1 'Sample App'",
               '/static_pages/home', 'h1', 'Sample App')

    checkvalue("should have the base title",
               '/static_pages/home', 'title', '')

    checknovalue("should not have a custom page title",
                 '/static_pages/home', 'title', '| Home')
  end

  describe "Help page" do

    checkvalue("should have the h1 'Help'",
               '/static_pages/help', 'h1', 'Help')

    checkvalue("should have the base title",
               '/static_pages/help', 'title', ' | Help')
  end

  describe "About page" do

    checkvalue("should have the h1 'About Us'",
               '/static_pages/about', 'h1', 'About Us')

    checkvalue("should have the base title",
               '/static_pages/about', 'title', ' | About Us')
  end

  describe "Contact page" do
    
    checkvalue("should have the h1 'Contact'",
               '/static_pages/contact', 'h1', 'Contact')

    checkvalue("should have the base title",
               '/static_pages/contact', 'title', ' | Contact')
  end
end
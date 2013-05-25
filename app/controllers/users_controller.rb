class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	# Create a new user, specifying the parameters from the
  	# POST method that were filled out by the user in the
  	# HTML form. params[:user] is a hash that contains the
  	# data needed to create a new user
  	@user = User.new(params[:user])

  	# Check if we were able to save the user
  	if @user.save
  		# We were, so sign in the user and redirect him to his profile page
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
  	else # We weren't able to save the user
  		# Render a new "Create Account" request
  		render 'new'
  	end
  end
end

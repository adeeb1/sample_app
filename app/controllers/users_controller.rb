class UsersController < ApplicationController
  # Use a before filter to arrange for the signed_in_user method to be called BEFORE the given actions. In this case, invoke signed_in_user before the "index," "edit," "update," and "destroy" actions are performed
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,    only: :destroy

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

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
  end

  def update
    # Check if we were able to update the user's attributes
    if @user.update_attributes(params[:user])
      # We were, so notify the user of this
      flash[:success] = "Profile updated"

      # Sign the user in because the remember token gets reset when the user is saved, effectively invalidating the user's session - nice security feature
      sign_in @user

      # Redirect the user to his/her profile
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."

    redirect_to users_url
  end

  private
    def signed_in_user
      store_location
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
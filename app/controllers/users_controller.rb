class UsersController < ApplicationController
  # Use a before filter to arrange for the signed_in_user method to be called BEFORE the given actions. In this case, invoke signed_in_user before the "index," "edit," "update," and "destroy" actions are performed
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,    only: :destroy

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    # Check if the user is logged in
    @user = current_user

    # Check if there is a logged-in user
    if !@user.nil?
      # There is, so bring the user to the home page
      redirect_to root_url
    else
      # There isn't, so create a new user
      @user = User.new
    end
  end

  def create
    # Check if the user is logged in
    @user = current_user

    # Check if there is a logged-in user
    if !@user.nil?
      # There is, so bring the user to the home page
      redirect_to root_url
    else # There isn't a logged-in user
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
    # Find the user that the admin chose to delete
    theuser = User.find(params[:id])

    # Make sure the user the admin chose to delete isn't himself
    if theuser != current_user then
      # Store the user's name in a temporary variable
      usersname = theuser.name

      # Delete the user
      theuser.destroy

      # State that we just deleted the user
      flash[:success] = "#{usersname} has been destroyed."

      # Redirect the admin to the "All users" page
      redirect_to users_url
    else # The user the admin chose to delete is himself
      # Redirect the admin to his profile page
      redirect_to current_user
    end
  end

  def following
    # Set the title of the page
    @title = "Following"
    
    # Get the user
    @user = User.find(params[:id])

    # Get all of the user's followed users and paginate them
    @users = @user.followed_users.paginate(page: params[:page])

    render 'show_follow'
  end

  def followers
    # Set the title of the page
    @title = "Followers"

    # Get the user
    @user = User.find(params[:id])

    # Get all of the user's followers and paginate them
    @users = @user.followers.paginate(page: params[:page])

    render 'show_follow'
  end

  private
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
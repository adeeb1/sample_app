class PasswordResetsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	user.send_password_reset if user
  	redirect_to root_url, notice: "An email containing instructions for resetting your password has been sent to your email address."
  end

  def edit
  	# Get the user by the password reset token. Use the bang method to return a 404 if the token isn't found
  	@user = User.find_by_password_reset_token!(params[:id])
  end

  def update
  	# Get the user based on the password reset token
  	@user = User.find_by_password_reset_token!(params[:id])

  	# Check if the reset token has been expired. This would occur if the password reset was sent earlier than 2 hours ago
  	if @user.password_reset_sent_at < 2.hours.ago
  		# Redirect the user to the new password reset path
  		redirect_to new_password_reset_path, alert: "Password reset has expired."
  	else # The reset token hasn't expired
      # Check if the new password's trimmed length is less than 6 characters long
      # Strip = Trim()
      if params[:user][:password].strip.length < 6 then
        # It is, so notify the user that the password must be at least 6 characters long and not contain any leading or trailing spaces by adding a custom error message
        @user.errors.add(:password, "must be at least 6 characters long and not contain any leading or trailing spaces")

        # render the 'edit' action
        render :edit

        # Edit the function
        return
      end
      
      # Check if the user's attributes, specifically the user's password, were updated
      if @user.update_attributes(params[:user]) then
        # The user's password was updated
        redirect_to root_url, notice: "Your password has been reset successfully!"

        # Edit the function
        return
      end

  		# Render the 'edit' action again if the user's reset token has expired and none of the user's attributes were updated
  		render :edit
  	end
  end
end
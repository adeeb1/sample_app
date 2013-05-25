class SessionsController < ApplicationController
	def new
	end

	def create
		# Get the user based on the submitted email address
		user = User.find_by_email(params[:session][:email].downcase)
		
		# Check if the user object isn't nil and that authentication was successful
		if user && user.authenticate(params[:session][:password])
			# The tests were successful, so sign the user in
			sign_in user

			# Redirect the user to his/her profile page
			redirect_to user
		else
			# Display the error message
			flash.now[:error] = 'Invalid email/password combination'
			
			# Re-render the signin form
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end

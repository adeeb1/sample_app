module SessionsHelper
	def sign_in(user)
		# Store the user's remember token in a cookie
		# The cookie is not a hash but acts as a hash of two elements: value and expires date (optional)
		cookies.permanent[:remember_token] = user.remember_token

		# Because of the current_user property specified below, this converts to:
		# current_user = current_user(user)
		self.current_user = user
	end

	def sign_out
		# Set the current user to nil
		self.current_user = nil

		# Remove the remember_token from the session
		cookies.delete(:remember_token)
	end

	def signed_in?
		!current_user.nil?
	end

	# Define the current_user method specifically for assigning the value of the current_user variable (basically a property)
	def current_user=(user)
		@current_user = user
	end

	# Set the instance variable of current_user to the user specified in the remember_token only if the instance of current_user is undefined. The below code can be rewritten as follows:

	# @current_user = @current_user || User.find_by_remember_token(cookies[:remember_token])

	# The code will return @current_user if the instance is not undefined 
	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_url, notice: "Please sign in."
		end
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url
	end
end
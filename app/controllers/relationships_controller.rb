class RelationshipsController < ApplicationController
	before_filter :signed_in_user

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)

		# Take the appropriate action depending on the kind of request (either HTML or Ajax)
		respond_to do |format|
			# Redirect the user to his home page if the request is HTML
			format.html { redirect_to @user }

			# In the case of an Ajax request, Rails automatically calls a JavaScript Embedded Ruby (.js.erb) file with the same name as the action (create.js.erb)
			format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)

		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end
class MicropostsController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user,   only: :destroy

	def create
		@micropost = current_user.microposts.build(params[:micropost])

		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			# Initialize an empty feed_items array just in case it wasn't possible to save the micropost
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private

		# This function can be rewritten using "find" instead of "find_by_id" and through exception handling. This is the alternative method:

		# def correct_user
		#     @micropost = current_user.microposts.find(params[:id])
		# rescue
		#     redirect_to root_url
		# end

		def correct_user
			# Find only microposts belonging to the current user
			@micropost = current_user.microposts.find_by_id(params[:id])

			# "find_by_id" returns "nil" if a micropost doesn't exist, while "find" raises an exception. Redirect the user to the home page if no microposts can be found
			redirect_to root_url if @micropost.nil?
		end
end
module UsersHelper
	# Returns the Gravatar (http://gravatar.com/) for the
	# given user
	def gravatar_for(user, options = { size: 70 })
		id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/" +
					   "avatar/#{id}?s=#{size}"

		return image_tag(gravatar_url, alt: user.name,
									   class: "gravatar")
	end
end

module ApplicationHelper

	# Returns the full title on a per-page basis
	def full_title(page_title)
		# Set the base title
		base_title = "Ruby on Rails Tutorial Sample App"

		# Check if a title was NOT specified on the page
		if page_title.empty?
			# It wasn't, so set the full title to the base
			# title
			return base_title
		else # A title was specified on the page
			# Concatenate the base title with the page's
			# title
			return "#{base_title} | #{page_title}"
		end
	end
end

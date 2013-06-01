module MicropostsHelper
	def wrap(content)
		# Use the 'raw' method to prevent Rails from escaping the resulting HTML and the 'sanitize' method to prevent cross-site scripting. After splitting the content, we call the 'map' method to loop through every element in the resulting array
		sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
	end

	private
	  	def wrap_long_string(text, max_width = 30)
			zero_width_space = "&#8203;"
			
			# Define a regex that we should use to delimit the text
			regex = /.{1,#{max_width}}/
			
			# Use a ternary conditional expression to get the value of 'text.' If text.length is >= max_width, then iterate through the text, splitting the text by the regex expression with the 'scan' method. Then, join each element in the resulting array with the zero_width_space 
			text = (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
	  	end
end
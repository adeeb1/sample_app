$(document).ready(function($)
{
	$('#micropost_content').change(function(e)
	{
		textbox = $('#micropost_content');
		charsleft = (140 - textbox.val().length);

		paragraph = $('#charsremaining');
		paragraph.innerHTML = charsleft + " characters remaining.";
	});
});
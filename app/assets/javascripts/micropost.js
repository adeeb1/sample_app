function UpdateCharsRemaining()
{
	var textbox = $('#micropost_content');
	var charsleft = (140 - textbox.val().length);

	var paragraph = $('#charsremaining');
	
	var text = charsleft + (charsleft != 1 ? " characters" : " character") + " remaining";

	paragraph.text(text);
}

$(document).ready(function($)
{
	UpdateCharsRemaining();

	$('#micropost_content').change(UpdateCharsRemaining);
	$('#micropost_content').keydown(UpdateCharsRemaining);
	$('#micropost_content').keyup(UpdateCharsRemaining);
});
extends Label

func _draw():
	var bg_text = ''
	for ch in text:
		bg_text += ' ' if ch == ' ' else '~'
	$BG.text = bg_text

extends TextureRect

var ach

func update_state(new_ach):
	var ach_obj = Settings.achievements[ach]
	texture = ach_obj['texture'] if ach_obj['done'] else Settings.ach_locked
	$Hint/Label.text = (
		ach_obj['title'] if ach_obj['done'] else '???'
	) + '\n' + ach_obj['hint']

func _ready():
	update_state('')
	Settings.connect("new_ach", self, "update_state")

func _make_custom_tooltip(for_text):
	var l = Label.new()
	l.text = for_text
	return l

func _on_Ach_mouse_entered():
	$Hint.visible = true

func _on_Ach_mouse_exited():
	$Hint.visible = false
